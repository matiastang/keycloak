<#import "template.ftl" as layout>
<#import "field.ftl" as field>
<#import "buttons.ftl" as buttons>
<@layout.registrationLayout displayInfo=true displayMessage=!messagesPerField.existsError('username'); section>
    <#if section = "header">
        ${msg("emailForgotTitle")}
    <#elseif section = "form">
        <form id="kc-reset-password-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
            <#assign label = (!realm.loginWithEmailAllowed)?then(msg("username"), (!realm.registrationEmailAsUsername)?then(msg("usernameOrEmail"), msg("email")))?trim>
            <@field.input name="username" label=label value=auth.attemptedUsername!'' autofocus=true />

            <@buttons.actionGroup>
              <@buttons.button id="kc-form-buttons" label="doSubmit" class=["kcButtonPrimaryClass", "kcButtonBlockClass"]/>
              <@buttons.buttonLink href=url.loginUrl label="backToLogin" class=["kcButtonSecondaryClass", "kcButtonBlockClass"]/>
            </@buttons.actionGroup>

        </form>
    <#elseif section = "info" >
        <span class="${properties.kcLoginMainFooterHelperText!}">
            <#if realm.duplicateEmailsAllowed>
                ${msg("emailInstructionUsername")}
            <#else>
                ${msg("emailInstruction")}
            </#if>
        </span>
    </#if>
</@layout.registrationLayout>
