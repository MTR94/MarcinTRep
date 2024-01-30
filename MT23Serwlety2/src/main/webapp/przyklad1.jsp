<%@ page import="java.time.LocalTime" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Przykład JSP 1</title>
</head>
<body>
<h1>Przykład JSP 1</h1>
<p>To jest zwykły HTML.</p>
<!-- To jest komentarz HTML - on będzie wysłany do klienta -->
<%-- To jest komentarz w JSP. Klient tego nie zobaczy --%>
<%-- Fragmenty HTML i zwykłego tekstu pisane w JSP są wysyłane w odpowiedzi do klienta.
Ale w plikach JSP można też umieszczać fragmenty kodu Java wewnątrz tzw. scriptlets. --%>
<% int liczba = 150;
    String napis = "Ala ma kota";
    out.println("Heja, " + napis);
%>

<%-- Istnieją specjalne wersje skryptletów.
   Powyżej widzielismy zwykły blok kodu.
   Poniżej zobaczymy wstawienie wartości do outputu: --%>

<p>Zmienna liczba ma wartość <%= liczba %></p>
<p>Bieżący czas: <%= LocalTime.now() %></p>

<%-- Kod umieszczony na poziomie klasy, a nie metody.
	Może zawierać deklaracje pól (w tym static) i metod. --%>

<%!
    static int licznik = 100;
    String dajGlos() {
        return "hau hau";
    }
%>
<p>Licznik: <%= licznik++ %></p>
<p>Metoda: <%= dajGlos() %></p>

</body>
</html>

<%-- Z pliku JSP powstaje klasa serwletu.
	Używanie skryptletów (fragmentów kodu Javy) jest uważane za złe podejście...
-->




