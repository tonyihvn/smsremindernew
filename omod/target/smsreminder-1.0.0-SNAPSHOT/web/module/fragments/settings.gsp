<%
    ui.includeJavascript("smsreminder", "jquery-3.3.1.js")
    ui.includeCss("smsreminder", "bootstrap.min.css")
    ui.includeJavascript("smsreminder", "bootstrap.min.js")
    ui.includeCss("smsreminder", "myStyle.css")
    def id = config.id
%>
<a class="btn btn-sm btn-primary" href="smsreminder.page">< Go Back</a>
<fieldset>
    <legend>Credentials</legend>

    <div class="row">
        <div class="col-sm-3 col-md-3"><label class="pull-right">Getway URL</label></div>

        <div class="col-sm-9 col-md-9">
            <input type="text" name="gateway_url" id="gateway_url" class="form-control"
                   placeholder="e.g. https://api.smsgateway.com/sendsms=sendsms"/>
        </div>
    </div>

    <div class="row">
        <div class="col-sm-3 col-md-3"><label class="pull-right">Gateway Username</label></div>

        <div class="col-sm-3 col-md-3">
            <input type="text" name="gateway_user" id="gateway_user" class="form-control"
                   placeholder="e.g username=xxxx"/>

        </div>

        <div class="col-sm-3 col-md-3"><label class="pull-right">Gateway Password</label></div>

        <div class="col-sm-9 col-md-3">
            <input type="text" name="gateway_pass" id="gateway_pass" class="form-control"
                   placeholder="e.g. password=xxxx"/>

        </div>

    </div>

    <div class="row">
        <div class="col-sm-3 col-md-3"><label class="pull-right">Phone Numbers Label</label></div>

        <div class="col-sm-3 col-md-3">
            <input type="text" name="gateway_phoneno" id="gateway_phoneno" class="form-control"
                   placeholder="e.g recipients="/>

        </div>

        <div class="col-sm-3 col-md-3"><label class="pull-right">Message Label</label></div>

        <div class="col-sm-9 col-md-3">
            <input type="text" name="gateway_message" id="gateway_message" class="form-control"
                   placeholder="e.g. message="/>

        </div>

    </div>

    <div class="row">
        <div class="col-sm-3 col-md-3"><label class="pull-right">Other Parameters</label></div>

        <div class="col-sm-9 col-md-9">
            <input type="text" name="gateway_url" id="gateway_url" class="form-control"
                   placeholder="e.g. message_type=1&route=2&..."/>
        </div>
    </div>

    <div class="row">
        <div class="col-sm-3 col-md-3"><label class="pull-right">Sender ID/Title Label</label></div>

        <div class="col-sm-3 col-md-3">
            <input type="text" name="gateway_title" id="gateway_title" class="form-control" placeholder="e.g sendid="/>

        </div>

        <div class="col-sm-3 col-md-6">
            <button class="btn btn-default pull-right" id="saveSMSCredentials">Save Gateway Credentials</button>
        </div>

    </div>

</fieldset>

<script type="text/javascript">

    var jq = jQuery;

    jq(document).ready(function (e) {

        jq("#saveSMSCredentials").click(function (e) {

            var gateway_url = jq('#gateway_url').val();
            var gateway_user = jq('#gateway_user').val();
            var gateway_pass = jq('#gateway_pass').val();
            var gateway_message = jq('#gateway_message').val();
            var gateway_title = jq('#gateway_title').val();
            var gateway_phoneno = jq('#gateway_phoneno').val();
            var gateway_other_params = jq('#gateway_other_params').val();

            jq.getJSON('${ui.actionLink("setSmsGatewayProps")}', {
                    gateway_url: gateway_url,
                    gateway_user: gateway_user,
                    gateway_pass: gateway_pass,
                    gateway_message: gateway_message,
                    gateway_title: gateway_title,
                    gateway_phoneno: gateway_phoneno,
                    gateway_other_params: gateway_other_params
                },
                function (response) {
                    console.log(response);

                    alert(respone);
                });


        });

    });



</script>