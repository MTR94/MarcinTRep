<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Przyklad 2 JSP</title>
</head>
<body>
<h1>JSP 2</h1>
<%-- Expression Language (EL) - wzorowany na wyrażeniach Javy, ale uproszczony, z delikatnymi równicami.
	Wyrażenia umieszcza się w znacznikach ${WYRAŻENIE}
	Wynik wyrażenia jest wypisywany na stronie.
	EL są też użwane w ramach "tagów" - za chwilę... --%>
<p>Wynik obliczenia: ${2 + 3 * 4}</p>

<%-- Najważniejszym zastosowaniem EL jest dostęp do obiektów tworzonych przez aplikację.
	Można zrobić tak, że to sam skrypt JSP tworzy obiekt, a następnie z niego korzysta;
	są też inne możliwości, m.in. sesja, co zobaczymy później. --%>
<jsp:useBean id="osoba" class="serwlety.beans.Osoba"/>
<p>Obiekt osoba: ${osoba}</p>
<jsp:setProperty name="osoba" property="imie" value="Ala"/>
<jsp:setProperty name="osoba" property="nazwisko" value="Kowalska"/>
<jsp:setProperty name="osoba" property="dataUrodzeniaTxt" value="2000-03-04"/>
<p>Obiekt osoba: ${osoba}</p>
<p>Pola obiektu:</p>
<ul>
    <li>${osoba.imie} ${osoba.nazwisko}</li>
    <li>${osoba.wiek}</li>
    <li>${osoba.dataUrodzenia}</li>
    <li>Rok urodzenia: ${osoba.dataUrodzenia.year}</li>
    <li>Który to był dzień roku? ${osoba.dataUrodzenia.dayOfYear}</li>
    <li>Metoda zwracająca długość miesiąca: ${osoba.dataUrodzenia.lengthOfMonth()}</li>
</ul>
<%-- Gdy wpisujemy odwołanie do obiektu, to jest on printowany za pomocą toString().
	Gdy wpiszemy coś, co wygląda na odczyt pola obiektu, to jest wywoływany getter zwracający to property,
	np. osoba.wiek powoduje wywołanie getWiek()
	Gdy wpiszemy coś z nawiasami na końcu, to jest to wywołanie metody,
--%>

<%-- Biblioteka tagów ("taglib") to jest zestaw poleceń zapisywanych w formie znaczników w obrębie JSP.
Te znaczniki zawsze są poprzedzane prefiksem, np. <c:if>....

Tagliby można definiować samodzielnie, ale w 98% przypadków używa się zestawu nazywanego JSTL
"Java Standard Tag Library"
--%>
<h3>Taglibs</h3>
<ul>
    <c:forEach var="i" items="5,10,15">
        <li>${i}
            <c:choose>
                <c:when test="${i % 2 == 0}">parzyste</c:when>
                <c:otherwise>nieparzyste</c:otherwise>
            </c:choose>
        </li>
    </c:forEach>
</ul>
</body>
</html>





