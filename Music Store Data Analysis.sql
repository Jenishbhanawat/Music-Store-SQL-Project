create database music_database;
use music_database;

-- Question Set 1
-- Q1 Who is the senior most employee based on job title?
select * from employee;
select distinct title, first_value(concat(first_name," ",last_name)) over(partition by title order by hire_date asc range between unbounded preceding and unbounded following) as full_name from employee;

-- Q2 Which countries have the most Invoices?
select * from invoice;
select billing_country, count(invoice_id) as no_of_invoices from invoice group by billing_country order by no_of_invoices desc;

-- Q3 What are top 3 values of total invoice?
select * from invoice;
select total from invoice order by total desc limit 3;

-- Q4 Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals
select * from invoice;
select billing_city, sum(total) as total_invoice from invoice group by billing_city order by total_invoice desc limit 1;

-- Q5 Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money
select * from customer;
select c.customer_id, concat(c.first_name," ",c.last_name) as full_name, sum(total) as total_spent  from customer as c right join invoice using(customer_id) group by c.customer_id, full_name order by total_spent desc limit 1;

-- Question Set 2
-- Q1 Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A
select * from genre;
select * from customer;
select * from track;
select distinct c.email, c.first_name, c.last_name, g.name from customer as c join invoice using(customer_id) join invoice_line using(invoice_id) join track using(track_id) join genre as g using(genre_id) where g.name like "%rock%" order by email ;

-- Q2 Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands
SELECT * FROM ARTIST;
select artist.name, count(track_id) as no_of_tracks from artist join album using(artist_id) join track using(album_id) join genre using(genre_id) where genre.name like "%rock%" group by artist.name order by no_of_tracks desc limit 10;

-- Q3 Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first
select * from track;
select name, milliseconds from track where milliseconds > (select avg(milliseconds) from track) order by milliseconds desc;


-- Question Set 3

-- Q1 Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent
select concat(c.first_name," ",c.last_name) as customer_name, artist.name as artist_name, sum(invoice.total) from customer as c join invoice using(customer_id) join invoice_line using(invoice_id) join track using(track_id) join album using(album_id) join artist using(artist_id) group by customer_name, artist.name ; 

-- Q2 We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres

select * from invoice;
select billing_country, genre_name from (select billing_country, genre.name as genre_name, count(invoice_id) as no_of_purchase, dense_rank() over (partition by billing_country order by count(invoice_id) desc) as rnk  from invoice join invoice_line using(invoice_id) join track using(track_id) join genre using(genre_id)  group by billing_country, genre.name) as abc where rnk = 1;

-- Q3 Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount

with cte as (select billing_country, concat(first_name, " ",last_name) as customer_name, round(sum(total),02) as total_spent, dense_rank() over (partition by billing_country order by sum(total) desc) as rnk from customer join invoice using(customer_id) group by billing_country, customer_name) select billing_country, customer_name, total_spent from cte where rnk =1;

