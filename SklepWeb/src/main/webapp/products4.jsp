<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="sql" uri="jakarta.tags.sql"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Lista produktów 4</title>
<link rel="stylesheet" type="text/css" href="styl.css">
</head>
<body>
<h1>Lista produktów - wersja 4 JSP</h1>
<p>W tej wersji korzystamy ze standardowej biblioteki tagów (JSTL), a dokładnie z jej fragmentu obsługującego SQL.</p>
<p>Bezpośrednio w JSP wykonamy zapytanie w bazie danych - to też jeszcze nie będzie najładniejszy styl...</p>

<%-- W tej wersji za pomocą dedykowanych tagów JSP zadamy zapytanie SQL.
 Ta wersja W OGÓLE nie używa klas stworzonych przez nas w projekcie; jest samowystarczalna.
--%>

<%-- "taglibs" - biblioteki tagów, zaimplementowane w Javie, a w JSP używa się ich za pomocą składni "tagowej" (dokładnie składni XML) --%>
<sql:setDataSource var="baza" driver="org.postgresql.Driver"
        url="jdbc:postgresql://localhost/sklep"
        user="kurs" password="abc123"/>

<sql:query dataSource="${baza}" scope="page" var="result">
SELECT * FROM products ORDER BY product_id
</sql:query>

<%-- .product_name  .price itp - to są nazwy kolumn w tabeli SQL --%>
<c:forEach var="row" items="${result.rows}">
        <div class="product">
        <h3>${row.product_name}</h3>
        <div class="price">${row.price}</div>
        <p>${row.description}</p>
        </div>
</c:forEach>

</body>
</html>
