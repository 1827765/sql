/* --------------------
   Dannys Diner case Study Questions
   --------------------*/
SELECT * FROM sales
-- 1. What is the total amount each customer spent at the restaurant?

SELECT customer_id, SUM(menu.price)
FROM sales
JOIN menu
ON sales.product_id = menu.product_id
GROUP BY customer_id;
-- 2. How many days has each customer visited the restaurant?
SELECT customer_id, COUNT(order_date)
FROM sales
GROUP BY customer_id;

-- 3. What was the first item from the menu purchased by each customer?
WITH CTE AS 
(
SELECT S.customer_id,product_name,
ROW_NUMBER() OVER(PARTITION BY S.customer_id ORDER BY S.order_date) ROWNUM
FROM sales S
JOIN menu M 
ON S.product_id = M.product_id
)
 SELECT customer_id,product_name FROM CTE 
 WHERE ROWNUM = 1
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

WITH CTE AS (
SELECT customer_id,product_name, RANK() OVER(PARTITION BY M.product_name ORDER BY S.order_date) RANK
FROM menu M 
JOIN sales S 
ON M.product_id = S.product_id)

SELECT customer_id, product_name, COUNT(product_name), MAX(RANK)
FROM CTE
GROUP BY customer_id, product_name
ORDER BY 4 DESC

-- 5. Which item was the most popular for each customer?
SELECT customer_id, product_name,COUNT(*),
DENSE_RANK() OVER(PARTITION BY S.customer_id ORDER BY COUNT(*) DESC)
FROM sales S 
JOIN menu M 
ON S.product_id = M.product_id
GROUP BY customer_id, product_name



-- 6. Which item was purchased first by the customer after they became a member?


-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
