<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=false; section>
<!-- template: select-authenticator.ftl -->

    <#if section = "header" || section = "show-username">
        <#if section = "header">
            ${msg("loginChooseAuthenticator")}
        </#if>
    <#elseif section = "form">

    <ul class="${properties.kcSelectAuthListClass!}" role="list">
        <#list auth.authenticationSelections as authenticationSelection>
            <li class="${properties.kcSelectAuthListItemWrapperClass!}">
                <form id="kc-select-credential-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
                    <input type="hidden" name="authenticationExecution" value="${authenticationSelection.authExecId}">
                </form>
                <div class="${properties.kcSelectAuthListItemClass!}" onclick="document.forms[${authenticationSelection?index}].requestSubmit()">
                    <div class="pf-v5-c-data-list__item-content">
                        <#-- 根据类型选择更贴切的图标 -->
                        <#assign selectionKey = (authenticationSelection.iconCssClass!'')?lower_case>
                        <#assign displayKey = (authenticationSelection.displayName!'')?lower_case>
                        <#assign isPassword = selectionKey?contains("password") || selectionKey?contains("username") || displayKey?contains("password") || displayKey?contains("username") || displayKey?contains("账号") || displayKey?contains("密码")>
                        <#assign isWeChat = selectionKey?contains("wechat") || selectionKey?contains("weixin") || displayKey?contains("wechat") || displayKey?contains("weixin") || displayKey?contains("微信")>
                        <#assign isPhone = selectionKey?contains("phone") || selectionKey?contains("sms") || displayKey?contains("phone") || displayKey?contains("sms")>
                        <#assign isEmail = selectionKey?contains("mail") || selectionKey?contains("email") || displayKey?contains("mail") || displayKey?contains("email")>
                        <#if isPassword>
                            <#assign iconClass = "fas fa-user">
                        <#elseif isWeChat>
                            <#assign iconClass = "fab fa-weixin">
                        <#elseif isPhone>
                            <#assign iconClass = "fas fa-mobile-alt">
                        <#elseif isEmail>
                            <#assign iconClass = "fas fa-envelope">
                        <#else>
                            <#assign iconClass = properties[authenticationSelection.iconCssClass]!authenticationSelection.iconCssClass>
                        </#if>
                        <div class="${properties.kcSelectAuthListItemIconClass!}">
                            <i class="${iconClass} ${properties.kcSelectAuthListItemIconPropertyClass!}"></i>
                        </div>
                        <div class="${properties.kcSelectAuthListItemBodyClass!}">
                            <div class="${properties.kcSelectAuthListItemHeadingClass!}">
                                ${msg('${authenticationSelection.displayName}')}
                            </div>
                            <div class="${properties.kcSelectAuthListItemDescriptionClass!}">
                                ${msg('${authenticationSelection.helpText}')}
                            </div>
                        </div>
                    </div>
                    <div class="${properties.kcSelectAuthListItemFillClass!}">
                        <i class="${properties.kcSelectAuthListItemArrowIconClass!}" aria-hidden="true"></i>
                    </div>
                </div>
            </li>
        </#list>
    </ul>

    </#if>
</@layout.registrationLayout>
