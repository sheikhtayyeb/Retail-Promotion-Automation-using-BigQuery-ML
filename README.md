# Retail-Offer-Pattern-Extractor-using-BigQuery-ML

## Overview

This project uses Google BigQuery and a generative language model to automatically extract structured information from unstructured retail promotion text. By analyzing phrases like "Buy 1, Get 1 Free" or "$10 off orders over $100", the system extracts key promotion attributes into a standardized format.

## Features

- **Automated Extraction**: Converts natural language promotion descriptions into structured data
- **Standardized Fields**: Extracts multiple promotion attributes including:
  - Minimum purchase amount
  - Coupon value type (percent off, money off, free gift)
  - Discount value (money amount or percentage)
  - Buy X, Get Y discount quantities
  - Free gift descriptions
  - Promotion pricing

## Technology

- **Google BigQuery**: SQL data warehouse for processing and storing data
- **LLM Integration**: Uses Gemini 2.0 Flash model via BigQuery ML for text extraction
- **BigQuery ML.GENERATE_TEXT**: Applies prompt engineering to extract structured fields

## SQL Implementation

The implementation uses a CREATE OR REPLACE MODEL statement to establish a remote connection to a language model, followed by a SELECT query that:

1. Processes retail promotion descriptions from a source table
2. Sends each promotion to the LLM with specific extraction instructions
3. Parses the structured response into individual columns
4. Returns a tabular result with all structured fields

## Example Use Cases

- **Retail Analytics**: Standardize promotion data across different systems and formats
- **Promotion Effectiveness Analysis**: Compare different promotion types across campaigns
- **Inventory Planning**: Understand promotion structures for better inventory forecasting
- **Customer Segmentation**: Analyze which promotion structures perform best for different customer segments

## Sample Inputs and Outputs

| Input Text | Output Structure |
|------------|------------------|
| "Complimentary 3-Pc. gift with $150 Dior purchase" | Minimum Purchase: $150.00<br>Type: free_gift<br>Gift: Complimentary 3-Pc. gift |
| "Nudestix Buy 3 get 30% off" | Type: percent_off<br>Discount: 30% |
| "Buy 1 toy, Get 2nd 50% Off" | Type: percent_off<br>Discount: 50%<br>Buy Quantity: 2<br>Get Discounted: 1 |

## Setup Requirements

- Google Cloud Platform account with BigQuery access
- Appropriate permissions to create ML models
- Connection to an LLM endpoint (Gemini 2.0 Flash in this example)

## Usage Instructions

1. Replace `$PROJECT` with your actual Google Cloud project ID
2. Ensure your dataset and table paths are correct
3. Configure the remote connection to your LLM endpoint
4. Run the query to process your promotion texts

## Performance Considerations

- Consider batching large promotion datasets for optimal performance
- Monitor quota usage when processing large volumes of text
- For production use, implement error handling for unexpected promotion formats
