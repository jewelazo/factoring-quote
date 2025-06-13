require "spec_helper"
require_relative "../factoring_quote"

RSpec.describe FactoringQuote do
  let(:user_input_data) do
    {
      seller_rut: "76329692-K",
      debtor_rut: "77360390-1",
      invoice_amount: 1_000_000,
      folio: 75,
      expiration_date: "2025-07-13"
    }
  end

  let(:api_response_data) do
    {
      "document_rate" => 1.09,
      "commission" => 0.0,
      "advance_percent" => 99.0
    }
  end

  subject(:quote_instance) do
    allow_any_instance_of(FactoringQuote).to receive(:get_user_data).and_return(user_input_data)
    allow_any_instance_of(FactoringQuote).to receive(:print_welcome)
    allow_any_instance_of(FactoringQuote).to receive(:print_exit)
    FactoringQuote.new
  end

  before do
    fake_response = double("HTTParty::Response", success?: true, parsed_response: api_response_data)
    allow(quote_instance).to receive(:get_api_response).and_return(fake_response)
  end

  describe "#calculate_quote" do
    before { quote_instance.calculate_quote }

    it "correctly calculates the quote amounts" do
      expect(quote_instance.quote[:financing_cost]).to be_within(1).of(11_150)
      expect(quote_instance.quote[:net_advance]).to be_within(1).of(978_849)
      expect(quote_instance.quote[:remaining]).to be_within(1).of(10_000)
    end
  end

  describe "#print_quote" do
    it "prints the expected formatted value" do
      quote_instance.calculate_quote
      expect {
        quote_instance.print_quote(quote_instance.quote)
      }.to output(include(
        "Costo de financiamiento: $11.150",
        "Giro a recibir: $978.849",
        "Excedentes: $10.000"
      )).to_stdout
    end
  end
end