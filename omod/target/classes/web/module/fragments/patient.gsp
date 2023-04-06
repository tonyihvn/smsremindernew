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

<nav>
    <div class="nav nav-tabs" id="nav-tab" role="tablist">
        <a class="nav-item nav-link active" id="nav-art-tab" data-toggle="tab" href="#nav-art" role="tab"
           aria-controls="nav-art" aria-selected="true">SMS Reminder</a>       
        <a class="nav-item nav-link" id="nav-all-settings" href="settings.page">Settings</a>
    </div>
</nav>

<h1 id="program">ART SMS Reminder Service</h1>
<div style="text-align: center"><h5 style="text-align: center !important; color: green; font-size: smaller;"><span>Last SMS Sent Date: <%=dformatter.formatDate(lastSentDate)%></span>
    </h5></div>
<fieldset>
    <legend>Filters</legend>

    <div class="row">
        <div class="col-sm-2 col-md-2">
            <select class="form-control" name="program_id" id="program_id">
                <option value="1" selected>ART</option>
                <option value="2" selected>PMTCT</option>
                <option value="6">COVID19</option>
                <option value="3" selected>HIV Exposed Infants</option>
                <option value="4" selected>HTS</option>
                <option value="5">OTZ</option>
                <option value="7">TB Treatment</option>
            </select>
        </div>

        <div class="col-sm-2 col-md-2"><label class="pull-right">Start date</label></div>

        <div class="col-sm-2 col-md-2">
            <input type="text" name="startDate" id="startDate" class="form-control date" readonly="readonly"/>
        </div>

        <div class="col-sm-2 col-md-2"><label class="pull-right">End date</label></div>

        <div class="col-sm-2 col-md-2">
            <input type="text" name="endDate" id="endDate" class="form-control date" readonly="readonly"/>
        </div>

        <div class="col-sm-2 col-md-2">
            <button class="btn btn-default" id="filterChart">Filter</button>
        </div>
    </div>
</fieldset>
<hr>

<div class="row">
    <%
        String allphonenos = "";
        String allappdates = "";
        if (patients != null && patients.size()) {
            for (int i = 0; i < patients.size(); i++) {
                if (i == patients.size() - 1) {
                    allphonenos = allphonenos + patients.get(i).get("phone_number").replace(' ', '').replace('-', ',');
                    allappdates = allappdates + patients.get(i).get("next_date");
                } else {
                    allphonenos = allphonenos + patients.get(i).get("phone_number").replace(' ', '').replace('-', ',') + ",";
                    allappdates = allappdates + patients.get(i).get("next_date") + ",";
                }
            }
        }
    %>

    <table>
        <tr>

            <td>
                <input type="radio" id="first" name="route" value="first">
                
                <label for="first" style="font-size: 9px;">Route 1</label><br>
                <input type="radio" id="second" name="route" value="second" checked>
                <label for="second" style="font-size: 9px;">Route 2</label>

            </td>
            <td>
                <select class="form-control" name="title" id="title" readonly>
                    <option value="ATTENTION" selected>ATTENTION</option>
                    <option value="READ">READ</option>
                    <option value="GREETINGS">GREETINGS</option>
                    <option value="REMINDER">REMINDER</option>
                    <option value="INVITATION">INVITATION</option>
                    <option value="THANK YOU">THANK YOU</option>
                </select>
            </td>
            <td><input type="text" id="message" name="message" value="" placeholder="Custom Message" class="form-control" readonly>
            </td>
            <td><a class="btn btn-primary btn-sm" style=" color: white !important" href="#" id="sendSMS" onclick="return confirm('Are you sure you want to send SMS to selected patients?')">Send SMS</a>
            </td>
            <td><a href="numberchecks.page" class="btn btn-warning btn-sm">Phone Number Validation</a></td>
            <!-- <td><a href="invalidnumbers.page" class="btn btn-danger btn-sm" style="color: white !important;">Invalid Numbers</a>-->

            <td><a href="sentmessages.page" class="btn btn-success btn-sm" style="color: white !important;">Sent Messages</a>
            </td>
        </tr>
    </table>

    
    <input name="allrecipients" type="hidden" id="allrecipients" value="<%=allphonenos%>">
    <input name="recipients" type="hidden" id="recipients">
    
    <input type="hidden" name="nextdates" id="nextdates" class="form-control" value="<%=allappdates%>">

    
    


    <h2 id="pagetitle" style="text-align: center !important;">Patients on Appointment for Tomorrow and Next</h2>

    <table id="filteredPatients">
        <thead>
        <tr>
            <th><input type="checkbox" id="select_all"><small style="white-space: nowrap;">Select All</small></th><th>Pepfar ID</th><th>Hospital No</th><th>Phone number</th><th>Next Appointment Date</th><th>Status/Action</th>
        </tr>
        </thead>

        <tbody>
        <%
            if (patients != null) {
                for (int i = 0; i < patients.size(); i++) {
        %>
        <tr>
            <td><input type="checkbox" value="select"
                       onClick="addNumber('<%= patients.get(i).get('phone_number').replace(' ','').replace('-',',')+"','"+patients.get(i).get('next_date'); %>')" class="num_selector"></td>
            <td><%=patients.get(i).get("pepfar_id") != null ? patients.get(i).get("pepfar_id") : "Negative"%></td>
            <td><%=patients.get(i).get("hospitalNumber")%></td>
            <%
                    String phoneno = patients.get(i).get("phone_number");
                    phoneno = phoneno.replaceAll(" ", "");
                    phoneno = phoneno.replaceAll("-", ",");
                    // patients.get(i).get("phone_number");
                    // if(phone_number").contains("-")
            %>
            <td><%=phoneno%></td>
            <td><%=dformatter.formatDate(patients.get(i).get("next_date"))%></td>
            <td  style="color: white !important;">

                <% if (patients.get(i).get("phone_number") == "" || patients.get(i).get("phone_number").length() < 11) { %>
                <a href="/<%=ui.contextPath() ;%>/registrationapp/editSection.page?patientId=${
                        patients.get(i).get("patient_id")}&sectionId=contactInfo&appId=referenceapplication.registrationapp.registerPatient"
                   class="btn btn-warning btn-sm small">Edit Invalid Number</a>
                <% } else { %>
                <a href="/<%=ui.contextPath() ;%>/registrationapp/editSection.page?patientId=${
                        patients.get(i).get("patient_id")}&sectionId=contactInfo&appId=referenceapplication.registrationapp.registerPatient"
                   class="btn btn-info btn-sm small">&#10004; Valid</a>
                <% } %>
            </td>
        </tr>
        <% }
        } %>

        </tbody>
    </table>

</div>

<script type="text/javascript">


    var jq = jQuery;

    jq(function () {
        jq(".date").datepicker({
            dateFormat: 'yy-mm-dd',
            changeYear: true,
            changeMonth: true,
            yearRange: "-30:+0",
            autoclose: true
        });
    });


    jq(document).ready(function (e) {
        // var patients2 = <%=pjson%>;
        // console.table(patients2);
        // alert(patients2[2]["phone_number"]);

        jq("#sendSMS").click(function (e) {

            var receivers = jq('#recipients').val();
            var nxtappdates = jq('#nextdates').val();
            var route = jq('input[name="route"]:checked').val();
            var message = jq('#message').val();
            var title = jq('#title').find(":selected").val()

            // var allPatients = new Array();
            var phoneNumbers1 = "";
            var phoneNumbers2 = "";
            var cleanedPhoneNumber = "";
            var phoneNumbersOthers = "";

            var message1 = "";
            var message2 = "";
            var messages = "";

            var d = new Date();
            var today = new Date(d.getFullYear() + "/" + (d.getMonth() + 1) + "/" + d.getDate());
            var patients = [];
            var nextdates = [];


            if (receivers !="") {

                // alert(JSON.stringify(nxtappdates));

                patients = receivers.split(",");
                nextdates = nxtappdates.split(",");

                for (let i = 0; i < patients.length; i++) {


                    cleanedPhoneNumber = patients[i];

                    var next_appointment = new Date(nextdates[i]);
                    var next_appointment_text = nextdates[i];
                    // console.log(nextdates[i]);
        
                    
                    next_appointment_text = next_appointment_text.replace(",", "-").replace(" ","-").substr(0, 10);

                    var daydiff = (next_appointment - today) / (1000 * 60 * 60 * 24);
                    var nodays = Math.round(daydiff);


                    // console.log(cleanedPhoneNumber+" No of Days "+nodays);

                    if (cleanedPhoneNumber.length >= 10) {
                        // console.log(cleanedPhoneNumber);

                        cleanedPhoneNumber.indexOf('0') == 0 ? cleanedPhoneNumber = cleanedPhoneNumber.replace('0', '234') : cleanedPhoneNumber;
                        if (cleanedPhoneNumber.substring(0, 3) != '234') {
                            cleanedPhoneNumber = '234' + cleanedPhoneNumber;
                        }

                        if (nodays > 0) {
                            if (i == patients.length) {
                                // phoneNumbers1 += cleanedPhoneNumber;
                                if(nodays==1){
                                    message1 += "A";
                                    phoneNumbers1 += cleanedPhoneNumber;
                                }else if(nodays==2){
                                    message2 += "AA";
                                    phoneNumbers2 += cleanedPhoneNumber;
                                }else{
                                    messages += "N"+next_appointment_text;
                                    phoneNumbersOthers += cleanedPhoneNumber;
                                }
                                // messages += "Next" + nodays + "Days";

                               

                            } else {
                                // phoneNumbers1 += cleanedPhoneNumber + ",";
                                if(nodays==1){
                                    message1 += "A,";
                                    phoneNumbers1 += cleanedPhoneNumber + ",";
                                }else if(nodays==2){
                                    message2 += "AA,";
                                    phoneNumbers2 += cleanedPhoneNumber + ",";
                                }else{
                                    messages += "N"+next_appointment_text+",";
                                    phoneNumbersOthers += cleanedPhoneNumber + ",";
                                }
                                // messages += "Next" + nodays + "Days,";
                                
                            }
                        } else {
                            if (i == patients.length - 1) {
                                phoneNumbersOthers += cleanedPhoneNumber;
                                messages += "M"+next_appointment_text;
                                // messages += "OverdueBy" + nodays + "Days";
                            } else {
                                phoneNumbersOthers += cleanedPhoneNumber + ",";
                                messages += "M"+next_appointment_text+",";
                                // messages += "OverdueBy" + nodays + "Days,";
                            }
                        }


                    }


                }

                // console.log(phoneNumbers1 + " " + route);
                // console.log(message);
                /*
                if (message != "") {
                    messages = message;
                }
                */

                if(phoneNumbers1!=""){
                    jq.getJSON('${ui.actionLink("sendSms")}', {
                            phoneNumbers1: phoneNumbers1,
                            messages: message1,
                            route: route,
                            message: message,
                            title: title
                        },
                        function (response) {
                            console.log(response);      
                        
                            if(response=="Successful"){
                                    alert("SMS Sent Successfully, Click OK continue!"); 
                            }else{
                                    alert("Unsuccessful! The message was not sent, check your network and try again"); 
                            }
                                             
                    });
                }

                if(phoneNumbers2!=""){
                    jq.getJSON('${ui.actionLink("sendSms")}', {
                            phoneNumbers1: phoneNumbers2,
                            messages: message2,
                            route: route,
                            message: message,
                            title: title
                        },
                        function (response) {
                            console.log(response);  
                            if(response=="Successful"){
                                    alert("SMS Sent Successfully, Click OK continue!"); 
                            }else{
                                    alert("Unsuccessful! The message was not sent, check your network and try again"); 
                            }
                        
                    });
                }

                if(phoneNumbersOthers!=""){
                    jq.getJSON('${ui.actionLink("sendSms")}', {
                            phoneNumbers1: phoneNumbersOthers,
                            messages: messages,
                            route: route,
                            message: message,
                            title: title
                        },
                        function (response) {
                            console.log(response); 
                            if(response=="Successful"){
                                    alert("SMS Sent Successfully, Click OK continue!"); 
                            }else{
                                    alert("Unsuccessful! The message was not sent, check your network and try again"); 
                            }
                            
                    });
                    
                    
                }

                

            }else{
                alert("Please select clients to continue!");

            }
            

        });

        


        jq("#filterChart").click(function (e) {
            jq("#tomorrow").hide();

            var startDate = jq("#startDate").val();
            var endDate = jq("#endDate").val();
            var program_id = jq("#program_id").val();

            myAjax({
                startDate: startDate,
                endDate: endDate,
                program_id: program_id
            }, '${ ui.actionLink("getFilteredPatientsList") }').then(function (response) {
                var data = JSON.parse(response);
                var patients = data;
                // console.table(patients);

                var html = "<table><thead><tr><th><input type='checkbox' id='select_all'><small style='white-space: nowrap;'>Select All</small></th><th>Pepfar ID</th><th>Hospital No</th><th>Phone number</th><th>Next Appointment Date</th><th>Status/Action</th></tr></thead><tbody>";


                if (patients != null) {
                    var allphonenos = "";
                    var allappdates = "";

                    for (var i = 0; i < patients.length; i++) {
                        let phno = patients[i]["phone_number"].replace(/ /g, "");

                        let phono = phno.replace(/ /g, "");
                        phono = phno.replace(/-/g, ",");
                        phono2 = "'" + phno.replace(/-/g, ",") + "'";

                        let nextdated = "'" + patients[i]["next_date"] + "'";
                        var pepfar_id = patients[i]["pepfar_id"] != null ? patients[i]["pepfar_id"] : "HIV Negative";
                        html += "<tr>";
                        html += '<td><input name="allrecip[]" type="checkbox" value="select" onClick="addNumber(' + phono2 + ',' + String(nextdated) + ')"></td>';
                        html += '<td>' + pepfar_id + '</td>';
                        html += '<td>' + patients[i]["hospitalNumber"] + '</td>';
                        html += '<td>' + phono + '</td>';
                        html += '<td>' + patients[i]["next_date"].substring(0, 10) + '</td>';
                        html += '<td><a href="../registrationapp/editSection.page?patientId=' + patients[i]["patient_id"] + '&sectionId=contactInfo&appId=referenceapplication.registrationapp.registerPatient" class="btn btn-info btn-sm small"> &#10004; Valid</a></td>';
                        html += "</tr>";
                        
                        if (i == patients.length - 1) {
                            allphonenos = allphonenos + phono;
                            allappdates = allappdates + patients[i]["next_date"].substring(0, 10);
                        } else {
                            allphonenos = allphonenos + phono + ",";
                            allappdates = allappdates + patients[i]["next_date"].substring(0, 10) + ",";
                        }
                    }
        
                    // jq('#recipients').val(allphonenos);
                    jq('#nextdates').val(allappdates);
                }

                html += "</tbody></table>";

                jq("#filteredPatients").html(html);

                jq("#pagetitle").text("Patients on Appointment Between " + startDate + " and " + endDate);
                   
                jq('#program').html("SMS REMINDER :"+jq('#program_id option:selected').text()+" Program");

            });
        });
        
        jq("#select_all").click(function (e) {          
            jq(".num_selector").each(function () { this.checked = !this.checked; });
            
            var allrec = jq("#allrecipients").val();
        
            if(jq("#select_all").is(":checked")){
        
                jq('#recipients').val(allrec);     
                jq('#recc').val(allrec);        

            }else{
                jq('#recipients').val("");
            }
        });
        
    });
        
    function addNumber(number, nextdate) {
        var receivers = jq('#recipients').val();
        var nextdates = jq('#nextdates').val();


        if (jq("#recipients").val().indexOf(',' + number) >= 0) {

            jq('#recipients').val(receivers.replace(',' + number, ''));
            jq('#nextdates').val(nextdates.replace(',' + nextdate, ''));

        } else if (jq("#recipients").val().indexOf(number + ',') >= 0) {

            jq('#recipients').val(receivers.replace(number + ',', ''));
            jq('#nextdates').val(nextdates.replace(nextdate + ',', ''));

        } else if (jq("#recipients").val().indexOf(number) >= 0) {

            jq('#recipients').val(receivers.replace(number, ''));
            jq('#nextdates').val(nextdates.replace(nextdate, ''));

        } else {
            if (receivers == "") {

                jq('#recipients').val(number);
                jq('#nextdates').val(nextdate);
            } else {
                jq('#recipients').val(receivers + ',' + number);
                jq('#nextdates').val(nextdates + ',' + nextdate);
            }

        }

    }

</script>