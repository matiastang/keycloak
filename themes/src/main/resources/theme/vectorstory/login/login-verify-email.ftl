<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=true; section>
    <#if section = "header">
        ${msg("emailVerifyTitle")}
    <#elseif section = "form">
        <p class="instruction">
            <#if verifyEmail??>
                ${msg("emailVerifyInstruction1",verifyEmail)}
            <#else>
                ${msg("emailVerifyInstruction4",user.email)}
            </#if>
        </p>
        <#if isAppInitiatedAction??>
            <form id="kc-verify-email-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
                <div class="${properties.kcFormGroupClass!}">
                    <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                        <#if verifyEmail??>
                            <input class="${properties.kcButtonClass!} ${properties.kcButtonDefaultClass!} ${properties.kcButtonLargeClass!}" type="submit" value="${msg("emailVerifyResend")}" />
                        <#else>
                            <input class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonLargeClass!}" type="submit" value="${msg("emailVerifySend")}" />
                        </#if>
                        <button class="${properties.kcButtonClass!} ${properties.kcButtonDefaultClass!} ${properties.kcButtonLargeClass!}" type="submit" name="cancel-aia" value="true" formnovalidate>${msg("doCancel")}</button>
                    </div>
                </div>
            </form>
        </#if>
    <#elseif section = "info">
        <#if !isAppInitiatedAction??>
            <script type="text/javascript">
                refreshVerifyEmailPage = () => {
                    const url = new URL(window.location.href);
                    if (url.searchParams.has("session_code")) {
                        url.searchParams.delete("session_code");
                        window.location.href = url.toString();
                        return;
                    }
                    window.location.reload();
                }
            </script>
            <p class="instruction">
                ${msg("emailVerifyInstruction2")}
                <br/>
                <a href="${url.loginAction}">${msg("doClickHere")}</a> ${msg("emailVerifyInstruction3")}
            </p>
            <div class="${properties.kcMarginTopClass!}">
                <button type="button" class="${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!}" onclick="refreshVerifyEmailPage()">
                    ${msg("emailVerifiedRefresh")}
                </button>
            </div>
        </#if>
    </#if>
</@layout.registrationLayout>
