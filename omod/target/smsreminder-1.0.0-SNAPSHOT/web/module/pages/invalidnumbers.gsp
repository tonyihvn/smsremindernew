<% ui.decorateWith("appui", "standardEmrPage") %>

<h2 style="text-align: center !important;">Patients with Invalid Phone Numbers</h2>
${ui.includeFragment("smsreminder", "invalidnumbers")}