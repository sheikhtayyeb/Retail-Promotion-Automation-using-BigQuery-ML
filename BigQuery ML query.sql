-- CREATE OR REPLACE MODEL
--   `$PROJECT.models.llm_modelv3` REMOTE
-- WITH CONNECTION `$PROJECT.us.llm-connection9599` OPTIONS (ENDPOINT = 'gemini-2.0-flash-001');


SELECT text,
       SPLIT(SPLIT(ml_generate_text_llm_result ,',')[0],':')[1] as MINIMUM_PURCHASE_AMOUNT,
       SPLIT(SPLIT(ml_generate_text_llm_result ,',')[1],':')[1] as COUPON_VALUE_TYPE,
       SPLIT(SPLIT(ml_generate_text_llm_result ,',')[2],':')[1] as MONEY_OFF_AMOUNT,
       SPLIT(SPLIT(ml_generate_text_llm_result ,',')[3],':')[1] as FREE_GIFT_DESCRIPTION,
       SPLIT(SPLIT(ml_generate_text_llm_result ,',')[4],':')[1] as PERCENT_OFF,
       SPLIT(SPLIT(ml_generate_text_llm_result ,',')[5],':')[1] as BUY_THIS_QUANTITY,
       SPLIT(SPLIT(ml_generate_text_llm_result ,',')[6],':')[1] as GET_THIS_QUANTITY_DISCOUNTED,
       SPLIT(SPLIT(ml_generate_text_llm_result ,',')[7],':')[1] as PROMOTION_PRICE
      FROM
      (SELECT text,ml_generate_text_llm_result FROM
      ML.GENERATE_TEXT(
        MODEL `$PROJECT.models.llm_modelv3`,
                ( SELECT * 
                  FROM(
                      WITH numbered_data AS (
                        SELECT
                          *,
                          ROW_NUMBER() OVER () AS row_num
                        FROM `$PROJECT.Dataset_1.retail-data1`
                      )
                    SELECT CONCAT(
      """ 
<system> You are an assistant that processes text based on retail offers and extracts information. Given a  text string  containing various types of retail offers, your task is to fetch and list all the offers for each row as in example. Here are three examples:                                                                      
<Text1> <Complimentary 3-Pc. gift with $150 Dior purchase>       
<Output> <MINIMUM_PURCHASE_AMOUNT:150.00 USD ,COUPON_VALUE_TYPE: free_gift, MONEY_OFF_AMOUNT:0.00 USD,FREE_GIFT_DESCRIPTION:Complimentary 3-Pc. gift, PERCENT_OFF: 0,BUY_THIS_QUANTITY:0, GET_THIS_QUANTITY_DISCOUNTED:0, PROMOTION_PRICE:0.00 USD.>           
 
<Text2> <Nudestix Buy 3 get 30% off>    
<Output> <MINIMUM_PURCHASE_AMOUNT:0.00 USD ,COUPON_VALUE_TYPE: percent_off, MONEY_OFF_AMOUNT:0.00 USD,FREE_GIFT_DESCRIPTION: , PERCENT_OFF: 30,BUY_THIS_QUANTITY:0, GET_THIS_QUANTITY_DISCOUNTED:0, PROMOTION_PRICE:0.00 USD.>  
                                
<Text3> <Buy 1 toy, Get 2nd 50% Off>
<Output> <MINIMUM_PURCHASE_AMOUNT:0.00 USD ,COUPON_VALUE_TYPE: percent_off, MONEY_OFF_AMOUNT:0.00 USD,FREE_GIFT_DESCRIPTION: , PERCENT_OFF: 50,BUY_THIS_QUANTITY:2, GET_THIS_QUANTITY_DISCOUNTED:1, PROMOTION_PRICE:0.00 USD.>                     

<Text4> <Buy 5 Get 1 Free on all>  
<Output> <MINIMUM_PURCHASE_AMOUNT:0.00 USD ,COUPON_VALUE_TYPE: '', MONEY_OFF_AMOUNT:0.00 USD,FREE_GIFT_DESCRIPTION:'' , PERCENT_OFF: 0,BUY_THIS_QUANTITY:5, GET_THIS_QUANTITY_DISCOUNTED:1, PROMOTION_PRICE:0.00 USD.>          

<Text5>  <Special offer: $10 off on orders over $100'>
<Output> <MINIMUM_PURCHASE_AMOUNT:100.00 USD ,COUPON_VALUE_TYPE: 'money_off', MONEY_OFF_AMOUNT:10.00 USD,FREE_GIFT_DESCRIPTION:'', PERCENT_OFF: 0,BUY_THIS_QUANTITY:0, GET_THIS_QUANTITY_DISCOUNTED:0, PROMOTION_PRICE:0.00 USD.>

      """
      , text) AS prompt, * 
                    FROM numbered_data
                    where row_num <20
                )),
                  STRUCT(
                    TRUE as flatten_json_output)
        )
      );
