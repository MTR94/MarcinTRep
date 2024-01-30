<%@page import="sklep.model.Product"%>
<%@page import="java.util.List"%>
<%@page import="sklep.db.ProductDAO"%>
<%@page import="sklep.db.DBConnection"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Lista produktów 3</title>
</head>
<body>
<h1>Lista produktów - wersja 3 JSP</h1>
<p>W tej wersji wewnątrz skryptu JSP umieścimy fragmenty Javy, tzw. scriptlets.
To jest pierwsza techniczna możliwość, którą oferował standard JSP.</p>

<p>Uwaga - ta wersja nadal jest nieporządna i <strong>nie jest</strong> wzorem do naśladowania.
    Mieszanie kodu HTML z Javą w taki sposób, szczególnie jak zrobiliśmy z pętlą pod koniec, jest w bardzo złym stylu.
</p>
<p>[<a href="index.html">powrót do spisu treści</a>]</p>

<%-- Poniżej skryptlet, który otwiera połączenie z bazą danych: --%>
<%
DBConnection db = DBConnection.open();
ProductDAO dao = db.productDAO();
%>
<p>Pobieranie danych...</p>
<%
List<Product> products = dao.readAll();
%>
<p>Pobrano <%= products.size() %> produktów. </p>
<h3>Wszystkie produkty</h3>
<ul>
<% for(Product product : products) { %>

    <li><%= product.getProductName() %> za <%= product.getPrice() %></li>

<% } %>
</ul>

<% db.close(); %>
<p>[<a href="index.html">powrót do spisu treści</a>]</p>
</body>
</html>
