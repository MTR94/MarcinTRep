<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lista produktów 8</title>
    <link rel="stylesheet" type="text/css" href="styl.css">
</head>
<body>

<div class="koszyk">
    <h4>Koszyk</h4>
    <ul>
        <%-- Zauważmy, że dla obiektu koszyk nie wykonujemy już useBean.
             Po prostu zakładamy, że jest obecny (w sesji). Gdyby go nie było, to pętla się nie wykona. --%>
        <c:forEach var="elm" items="${basket.elements}">
            <li>${elm.productName} (${elm.quantity}) za <b>${elm.value}</b></li>
        </c:forEach>
    </ul>
    <p class="total">Do zapłaty: ${basket.totalValue}</p>
</div>

<h1>Lista produktów - wersja 8</h1>

<form id="wyszukiwarka" method="get">
    <h2>Filtr cen</h2>
    <table class="formularz">
        <tr><td><label for="min_price">Cena minimalna:</label></td>
            <td><input type="number" name="min_price" value="${param.min_price}"></td></tr>
        <tr><td><label for="max_price">Cena maksymalna:</label></td>
            <td><input type="number" name="max_price" value="${param.max_price}"></td></tr>
        <tr><td><button>Filtruj</button></td></tr>
    </table>
</form>

<jsp:useBean id="productBean" class="sklep.web.ProductBean"/>
<jsp:setProperty name="productBean" property="minPrice" param="min_price"/>
<jsp:setProperty name="productBean" property="maxPrice" param="max_price"/>

<c:forEach var="product" items="${productBean.filteredProducts}">
    <div class="product">
        <img class="photo" src="photo?productId=${product.productId}" alt=""/>
        <h3>${product.productName}</h3>
        <div class="price">Cena: ${product.price}</div>
        <div class="price">VAT ${p.vat * 100}%</div>
        <c:if test="${not empty(product.description)}">
            <p class="description">${product.description}</p>
        </c:if>
        <div class="action"><a href="add_to_basket?productId=${product.productId}">dodaj do koszyka</a></div>
    </div>
</c:forEach>

</body>
</html>



