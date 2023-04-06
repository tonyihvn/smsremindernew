<%@ include file="/WEB-INF/template/include.jsp" %>

<%@ include file="/WEB-INF/template/header.jsp" %>

<h2><spring:message code="smsreminder-omod.title"/></h2>

<br/>
<table>
    <tr>
        <th>User Id</th>
        <th>Phone Number</th>
        <th>Next Appointment Date</th>
    </tr>
    <c:forEach var="user" items="${patients}">
        <tr>
            <td>${patients.patient_id}</td>
            <td>${patients.phone_number}</td>
            <td>${patients.next_date}</td>
        </tr>
    </c:forEach>
</table>

<%@ include file="/WEB-INF/template/footer.jsp" %>
