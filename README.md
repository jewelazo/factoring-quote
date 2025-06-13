# Factoring Quote Calculator

A simple Ruby application to calculate factoring quotes based on invoice details and debtor information using a external api.

## Description

This application helps calculate factoring quotes by taking inputs such as:
- Seller RUT
- Debtor RUT
- Invoice amount
- Invoice folio
- Expiration date

The calculator provides:
- Financing cost
- Net advance amount
- Remaining amount


## Requirements

- Ruby 3.4+
- Bundler
- HTTParty gem
- Rspec

## Installation

### Using Docker

1. Clone the repository
```bash
git clone https://github.com/jewelazo/factoring-quote.git
cd factoring-quote
```

2. Build the Docker image
```bash
docker build -t factoring-quote .
```

3. Run the container
```bash
docker run -it --rm factoring-quote bash
```
4. Run the application
```bash
ruby factoring_quote.rb
```
5. Run tests
```bash
rspec spec/factoring_quote_spec.rb
```

### Without Docker

1. Clone the repository
```bash
git clone https://github.com/jewelazo/factoring-quote.git
cd factoring-quote
```

2. Install dependencies
```bash
bundle install
```

3. Run the application
```bash
ruby factoring_quote.rb
```
4. Run tests
```bash
rspec spec/factoring_quote_spec.rb
```


## Usage

1. When prompted, enter the required information:
   - Seller RUT
   - Debtor RUT
   - Invoice amount
   - Invoice folio
   - Expiration date (YYYY-MM-DD format)

2. The application will calculate and display:
   - Financing cost
   - Net advance amount
   - Remaining amount

## API Integration

This application uses an external API for quote calculations. Make sure you have a valid API key.