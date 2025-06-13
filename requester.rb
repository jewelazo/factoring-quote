require "uri"

module Requester
  def get_user_input(mensaje, tipo: :string)
    print mensaje
    date_regex = /^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$/
    input = gets.chomp

    case tipo
    when :integer
      until input.match?(/^\d+$/)
        print "Por favor, ingrese un número válido. #{mensaje}"
        input = gets.chomp
      end
      input.to_i
    when :string
      input
    when :fecha
      until !!(input =~ date_regex)
        print "Por favor, ingrese una fecha válida (YYYY-MM-DD). #{mensaje}"
        input = gets.chomp
      end
      input
    else
      input
    end
  end

  def get_user_data
    {
      api_key: get_user_input("Ingrese un api-key válido: "),
      seller_rut: get_user_input("Ingrese RUT emisor: "),
      debtor_rut: get_user_input("Ingrese RUT deudor: "),
      invoice_amount: get_user_input("Ingrese monto factura: ", tipo: :integer),
      folio: get_user_input("Ingrese folio: ", tipo: :integer),
      expiration_date: get_user_input("Ingrese fecha vencimiento (YYYY-MM-DD): ", tipo: :fecha),
    }
  end

  def build_quote_url(kwargs)
    base_url = "https://chita.cl/api/v1/pricing/simple_quote"
    params = {
      client_dni: kwargs[:seller_rut],
      debtor_dni: kwargs[:debtor_rut],
      document_amount: kwargs[:invoice_amount],
      folio: kwargs[:folio],
      expiration_date: kwargs[:expiration_date],
    }
    query = URI.encode_www_form(params)
    "#{base_url}?#{query}"
  end

  def get(url, headers = {})
    HTTParty.get(url, headers: headers)
  rescue HTTParty::Error, SocketError => e
    puts "Error al conectar con la API: #{e.message}"
    nil
  end
end
