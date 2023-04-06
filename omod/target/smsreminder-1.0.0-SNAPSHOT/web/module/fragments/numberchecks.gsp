<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.css">

<script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.11.3/js/jquery.dataTables.js"></script>

<div class="row">

    <h5 style="text-align: center; color: green; font-size: smaller;">Last Phone Number Validation: <%=dformatter.formatDate(lastNumberChecks)%></h5>
    <a href="/<%=ui.contextPath() ;%>/smsreminder/smsreminder.page" style="float: left"><< Appointment Reminder</a>
    <a href="#" id="validate" class="btn btn-primary btn-sm" style="float: left">--- Validate All From Network</a>
    <hr>

    <table id="phonenumbers">
        <thead>
        <tr>
            <th>SN</th><th>Pepfar ID</th><th>Consent Given</th><th>Phone number</th><th>Comment/Remarks</th><th>Status/Action</th>
        </tr>
        </thead>

        <tbody>
        <% for (int i = 0; i < numbers.size(); i++) { %>
        <tr>
            <td><%=i + 1%></td>
            <td><%=numbers.get(i).get("pepfar_id") ;%></td>
            <td><input id="consent<%=i%>" onClick="unHide(<%=i%>)" placeholder="Enter 'Yes'"
                       value="<%=numbers.get(i).get("consent") == null ? "" : numbers.get(i).get("consent")%>"
                       style="border: none !important"/> <a href="#" class="savebtn" id="phone<%=i%>"
                                                            onClick="saveConsent('consent' +<%=i%>, <%= numbers.get(i).get("patient_id"); %>)">Save</a>
            </td>
            <td><a href="tel:<%=numbers.get(i).get("phone_number") ;%>"><%=
                    numbers.get(i).get("phone_number") ;%> &phone;</a></td>
            <td><input id="comment<%=i%>" onClick="unHide(<%=i%>)" placeholder="Enter Comments"
                       value="<%=numbers.get(i).get("comment") == null ? "" : numbers.get(i).get("comment")%>"
                       style="border: none !important"/> <a href="#" class="savebtn" id="phone<%=i%>"
                                                            onClick="saveComment('comment' +<%=i%>, <%= numbers.get(i).get("patient_id"); %>)">Save</a>
            </td>

            <td>
                <% if (numbers.get(i).get("phone_number") == "" || numbers.get(i).get("phone_number").length() < 11 || dformatter.isNumeric(numbers.get(i).get("phone_number")) == false) { %>
                <a href="/<%=ui.contextPath() ;%>/registrationapp/editSection.page?patientId=${
                        numbers.get(i).get("patient_id")}&sectionId=contactInfo&appId=referenceapplication.registrationapp.registerPatient"
                   class="btn btn-warning small" style="color: red">Edit Invalid Number</a>
                <% } else { %>
                <a href="/<%=ui.contextPath() ;%>/registrationapp/editSection.page?patientId=${
                        numbers.get(i).get("patient_id")}&sectionId=contactInfo&appId=referenceapplication.registrationapp.registerPatient"
                   class="btn btn-success" style="color: green">&#10004; Valid</a>
                <% } %>
            </td>

        </tr>
        <% } %>

        </tbody>
    </table>

</div>
<script type="text/javascript">


    var jq = jQuery;
    jq(document).ready(function () {
        jq('#phonenumbers').DataTable();

        jq(".savebtn").hide();


        // var receivers = jq('#recipients').val();

    });

    function unHide(savenum) {
        jq("#phone" + savenum).show();
    }

    function saveComment(comment, patientId) {
        var cmmt = jq("#" + comment).val();

        jq.getJSON('${ui.actionLink("saveComment")}', {comment: cmmt, patient_id: patientId},
            function (response) {
                console.log(response);
            });
    }
    
    function saveConsent(consent, patientId) {
        var cmmt = jq("#" + consent).val();

        jq.getJSON('${ui.actionLink("saveConsent")}', {consent: cmmt, patient_id: patientId},
            function (response) {
                console.log(response);
            });
    }

    jq.getJSON('${ui.actionLink("validateNumbers")}', {
            // allNumbers: allnumbers,
            messages: messages,
            route: route,
            message: message,
            title: title
        },
        function (response) {
            console.log(response);

            alert("SMS Sent Successfully, Click OK continue!");
        });

</script>
