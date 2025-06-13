require "httparty"
require "date"
require_relative "./presenter"
require_relative "./requester"

class FactoringQuote
  include Presenter
  include Requester
  attr_reader :api_key, :seller_rut, :debtor_rut, :invoice_amount, :folio, :expiration_date, :term, :quote

  def initialize
    print_welcome
    datos = get_user_data
    @api_key = datos[:api_key]
    @seller_rut = datos[:seller_rut]
    @debtor_rut = datos[:debtor_rut]
    @invoice_amount = datos[:invoice_amount]
    @folio = datos[:folio]
    @expiration_date = datos[:expiration_date]
    @term = (Date.parse(@expiration_date) - Date.today).to_i
  end

  def calculate_quote
    response = get_api_response.parsed_response.transform_keys(&:to_sym)
    gross_advance = invoice_amount * response[:advance_percent] / 100
    financing_cost = (gross_advance) * ((response[:document_rate] / 100) / 30 * (term + 1))
    @quote = { financing_cost: financing_cost,
               net_advance: (gross_advance) - (financing_cost + response[:commission]),
               remaining: invoice_amount - (gross_advance) }
  end

  def amount_formatter(amount)
    amount.to_i.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1.').reverse
  end

  def query_params
    { seller_rut: seller_rut, debtor_rut: debtor_rut, invoice_amount: invoice_amount, folio: folio, expiration_date: expiration_date }
  end

  def get_api_response
    url = build_quote_url(query_params)
    headers = { "X-Api-Key" => api_key }

    response = get(url, headers)

    unless response&.success?
      puts "\n⚠️  Error desde la API:"
      puts({ code: response.code, error: response&.parsed_response.to_s })
      exit 1
    end
    response
  end

  def print_quote(kwargs)
    puts "Resultado:"
    puts "Costo de financiamiento: $#{amount_formatter(kwargs[:financing_cost])}"
    puts "Giro a recibir: $#{amount_formatter(kwargs[:net_advance])}"
    puts "Excedentes: $#{amount_formatter(kwargs[:remaining])}"
    print_exit
  end

  def start
    calculate_quote
    print_quote(quote)
  end
end

if $PROGRAM_NAME == __FILE__
  quote = FactoringQuote.new
  quote.start
end
