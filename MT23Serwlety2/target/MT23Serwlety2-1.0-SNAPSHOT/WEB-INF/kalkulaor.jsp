<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>Mnożenie dwóch liczb</title>
</head>
<body>
<h1>Pomnóż dwie liczby</h1>
<form>
  <label for="liczba1">Pierwsza liczba:</label>
  <input id="liczba1" name="liczba1" type="number">
  <br/>
  <label for="liczba2">Druga liczba:</label>
  <input id="liczba2" name="liczba2" type="number">
  <br/>
  <button>Pomnóż</button>
</form>

<c:if test="${not empty(param.liczba1) and not empty(param.liczba2)}">
  <div>${param.liczba1} × ${param.liczba2} = <strong>${param.liczba1 * param.liczba2}</strong></div>
</c:if>

</body>
</html>

