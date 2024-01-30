<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Kalkulator w JSP</title>
  <link rel="stylesheet" type="text/css" href="styl.css">
</head>
<body>
<h1>Kalkulator w JSP</h1>

<form class="kalkulator" method="post">
  <input type="number" name="arg1" value="${param.arg1}">

  <select name="operacja">
    <c:forEach var="op" items="+,-,*,/">
      <c:choose>
        <c:when test="${op == param.operacja}">
          <option value="${op}" selected="selected">${op}</option>
        </c:when>
        <c:otherwise>
          <option value="${op}">${op}</option>
        </c:otherwise>
      </c:choose>
    </c:forEach>
  </select>

  <input type="number" name="arg2" value="${param.arg2}">
  <button style="color:red;font-weight:bold">Oblicz</button>
</form>


<jsp:useBean id="kalkulatorBean" class="serwlety.beans.KalkulatorBean"/>
<jsp:setProperty name="kalkulatorBean" property="arg1" param="arg1"/>
<jsp:setProperty name="kalkulatorBean" property="arg2" param="arg2"/>
<jsp:setProperty name="kalkulatorBean" property="operacja" param="operacja"/>

<c:if test="${not empty param.operacja}">
  <div class="wynik">
      ${kalkulatorBean.arg1} ${kalkulatorBean.operacja} ${kalkulatorBean.arg2} =
    <strong>${kalkulatorBean.wynik}</strong>
  </div>
</c:if>

</body>
</html>
