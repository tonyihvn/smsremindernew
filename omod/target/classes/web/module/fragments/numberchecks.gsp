<%
    ui.includeJavascript("smsreminder", "jquery-3.3.1.js")
    ui.includeJavascript("smsreminder", "jquery.dataTables.min.js")
    ui.includeJavascript("smsreminder", "datatables.min.js")
    ui.includeJavascript("smsreminder", "buttons.flash.min.js")
    ui.includeJavascript("smsreminder", "jquery-ui.js")
    ui.includeJavascript("smsreminder", "jszip.min.js")
    ui.includeJavascript("smsreminder", "myAjax.js")
    ui.includeJavascript("smsreminder", "pdfmake.min.js")
    ui.includeJavascript("smsreminder", "vfs_fonts.js")
    ui.includeCss("smsreminder", "bootstrap.min.css")
    ui.includeJavascript("smsreminder", "bootstrap.min.js")
    ui.includeJavascript("smsreminder", "buttons.html5.min.js")
    ui.includeJavascript("smsreminder", "buttons.print.min.js")
    ui.includeJavascript("smsreminder", "datatable.button.min.js")
    ui.includeCss("smsreminder", "buttons.dataTables.min.css")
    ui.includeCss("smsreminder", "jquery.dataTables.min.css")
    ui.includeCss("smsreminder", "myStyle.css")
    def id = config.id
%>

<div class="row">

    <h5 style="text-align: center; color: green; font-size: smaller;">Last Consent Exercise: <%=dformatter.formatDate(lastNumberChecks)%></h5>
    <a href="/<%=ui.contextPath() ;%>/smsreminder/smsreminder.page" style="float: left"><< Appointment Reminder</a>
    <a href="#" id="validate" class="btn btn-primary btn-sm" style="float: left">--- Validate All From Network</a>
    <hr>

    <table id="filteredPatients" class="table table-responsive">
        <thead>
        <tr>
            <th>SN</th><th>Pepfar ID</th><th>Consented</th><th>Consent Given?</th><th>Phone number</th><th>Status/Action</th>
        </tr>
        </thead>

        <tbody>
        <% for (int i = 0; i < numbers.size(); i++) { %>
        <tr>
            <td><%=i + 1%></td>
            <td><%=numbers.get(i).get("pepfar_id") ;%></td>
            <td><%=numbers.get(i).get("consent") == null ? "No" : numbers.get(i).get("consent")%></td>
            <td>
                <select class="form-control" name="title"  id="consent<%=i%>"  onChange="unHide(<%=i%>)">
                    <option value="<%=numbers.get(i).get("consent") == null ? "No" : numbers.get(i).get("consent")%>" selected><%=numbers.get(i).get("consent") == null ? "No" : numbers.get(i).get("consent")%></option>
                    <option value="Yes">Yes</option>
                    <option value="No">No</option>
                   
                </select>
                 <a href="#" class="savebtn" id="phone<%=i%>" onClick="saveConsent('consent' +<%=i%>, <%= numbers.get(i).get("patient_id"); %>)">Save</a>
            </td>
            <td><a href="tel:<%=numbers.get(i).get("phone_number") ;%>"><%=
                    numbers.get(i).get("phone_number") ;%> &phone;</a></td>
           
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
        jq('#filteredPatients').DataTable();

        jq(".savebtn").hide();


        // var receivers = jq('#recipients').val();
        
        jq('#filteredPatients thead tr').clone(true).appendTo('#filteredPatients thead');
        jq('#filteredPatients thead tr:eq(1) th:not(:last)').each(function(i) {
            var title = jq(this).text();
            jq(this).html('<input type="text" class="form-control" placeholder="Search ' + title + '" value="" style="width: 100%;" />');

            jq('input', this).on('keyup change', function() {
                if (table.column(i).search() !== this.value) {
                    table
                        .column(i)
                        .search(this.value)
                        .draw();
                }
            });
        });


        var table = jq('#filteredPatients').DataTable({
            orderCellsTop: true,
            fixedHeader: true,
            "order": [
                [5, "asc"]
            ],
            "paging": false,
            "pageLength": 50,
            "filter": true,
            "ordering": true,
            deferRender: true,
            dom: 'Bfrtip',
            buttons: [
                'copy', 'csv', 'excel', 'pdf', 'print'
            ]
        });
    });


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

    

</script>
