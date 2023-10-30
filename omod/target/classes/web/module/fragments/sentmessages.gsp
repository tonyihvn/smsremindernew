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

<fieldset>
    <legend>Filters</legend>

    <div class="row">
        
        <div class="col-sm-1 col-md-1"><label class="pull-right">Start date</label></div>

        <div class="col-sm-2 col-md-2">
            <input type="text" name="startDate" id="startDate" class="form-control date" readonly="readonly"/>
        </div>

        <div class="col-sm-1 col-md-1"><label class="pull-right">End date</label></div>

        <div class="col-sm-2 col-md-2">
            <input type="text" name="endDate" id="endDate" class="form-control date" readonly="readonly"/>
        </div>

        <div class="col-sm-2 col-md-2">
            <button class="btn btn-default" id="filterChart">Filter</button>
        </div>
        
        <div class="col-sm-2 col-md-2">
            <a href="/<%=ui.contextPath() ;%>/smsreminder/smsreminder.page" class="btn btn-warning btn-sm btn-inline">Send Message</a>
        
        </div>
        <div class="col-sm-2 col-md-2">
            <a class="btn btn-primary btn-inline btn-sm" style="color: white !important;" href="#" onClick="window.location.reload();">Reload-Page</a>
        </div>
    </div>
    
</fieldset>
<hr>


    <hr>

        <div id="sentmessagesArea">Retrieving sent messages, please wait ...</div>
        <h6>Note: You can see report for last 30 days </h6>
    <div style="float: right; text-align: right;">
        <a class="btn btn-" id="pageNumberPlus" data-page-number="1" href="#">Next Page</a>
    </div>
     

        
<script type="text/javascript">

    var jq = jQuery;

    jq(document).ready(function (e) {

        var pageNumber = jq("#pageNumberPlus").data("page-number");
        var elementClicked;
        jq("#pageNumberPlus").click(function (e) {
            jq("#pageNumberPlus").data("page-number", pageNumber++);
            elementClicked = true;
            myAjax({
                pageNumber: pageNumber
            }, '${ ui.actionLink("getSentMessages") }').then(function (response) {
                var sentmessages = JSON.parse(response);
                console.table(sentmessages);
                var facilityDatimCode = "<%=facilityDatimCode%>";
                var html = "<table id='sentmsgs'><thead><tr><th>Pepfar ID</th><th>Phone number</th><th>Message</th><th>Delivery Status</th><th>Date</th></tr></thead><tbody>";


                if (sentmessages != null) {

                    for (var i = 0; i < sentmessages.length; i++) {


                        if(sentmessages[i]["messageText"].slice(-11)==facilityDatimCode) {

                            html += "<tr>";
                            html += '<td>-</td>';
                            html += '<td>' + sentmessages[i]["mobileNumber"] + '</td>';
                            html += '<td>' + sentmessages[i]["messageText"].slice(0, -13) + '</td>';
                            html += '<td>' + sentmessages[i]["reports"][0]["status"] + '</td>';
                            html += '<td>' + sentmessages[i]["submitDate"] + '</td>';

                            html += "</tr>";
                        }

                    }

                    html += "</tbody></table>";

                    jq("#sentmessagesArea").html(html);

                    jq('#sentmsgs').DataTable({
                        pagingType: 'full_numbers',
                    });
                }

            });
        });

        if( elementClicked != true ) {
            alert(pageNumber);
            myAjax({
                pageNumber: pageNumber
            }, '${ ui.actionLink("getSentMessages") }').then(function (response) {
                var sentmessages = JSON.parse(response);
                console.table(sentmessages);
                var facilityDatimCode = "<%=facilityDatimCode%>";
                var html = "<table id='sentmsgs'><thead><tr><th>Pepfar ID</th><th>Phone number</th><th>Message</th><th>Delivery Status</th><th>Date</th></tr></thead><tbody>";


                if (sentmessages != null) {

                    for (var i = 0; i < sentmessages.length; i++) {


                        if(sentmessages[i]["messageText"].slice(-11)==facilityDatimCode) {

                            html += "<tr>";
                            html += '<td>-</td>';
                            html += '<td>' + sentmessages[i]["mobileNumber"] + '</td>';
                            html += '<td>' + sentmessages[i]["messageText"].slice(0, -13) + '</td>';
                            html += '<td>' + sentmessages[i]["reports"][0]["status"] + '</td>';
                            html += '<td>' + sentmessages[i]["submitDate"] + '</td>';

                            html += "</tr>";
                        }

                    }

                    html += "</tbody></table>";

                    jq("#sentmessagesArea").html(html);

                    jq('#sentmsgs').DataTable({
                        pagingType: 'full_numbers',
                    });
                }

            });

        }








    });










</script>