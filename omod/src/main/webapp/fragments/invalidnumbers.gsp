<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.css">

<script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.11.3/js/jquery.dataTables.js"></script>

<div class="row">

    <a href="smsreminder/smsreminder.page" style="float: left"><< Appointment Reminder</a>
    <hr>

    <table id="phonenumbers">
        <thead>
        <tr>
            <th>Pepfar ID</th><th>Hospital No</th><th>Phone number</th>
        </tr>
        </thead>

        <tbody>
        <% for (int i = 0; i < numbers.size(); i++) {
            if (numbers.get(i).get("phone_number") == "" || numbers.get(i).get("phone_number").length() < 11 || dformatter.isNumeric(numbers.get(i).get("phone_number")) == false) { %>
        <tr>

            <td><%=numbers.get(i).get("pepfar_id") ;%></td>
            <td><%=numbers.get(i).get("hospitalNumber") ;%></td>


            <td><a href="tel:<%=numbers.get(i).get("phone_number") ;%>"><%=
                    numbers.get(i).get("phone_number") ;%> &phone;</a></td>

        </tr>
        <% }
        } %>

        </tbody>
    </table>

</div>