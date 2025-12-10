<#import "template.ftl" as layout>
<#import "field.ftl" as field>
<@layout.registrationLayout displayInfo=true; section>
<!-- template: phone-verification.ftl -->

    <#if section = "header">
        ${msg("phoneVerificationTitle","验证手机号")}
    <#elseif section = "form">
        <form id="kc-phone-verification-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">

            <#-- 手机号显示（只读） -->
            <div class="${properties.kcFormGroupClass!}">
                <label for="phoneNumber" class="${properties.kcFormLabelClass!}">
                    <span class="${properties.kcFormLabelTextClass!}">${msg("phoneNumber","手机号")}</span>
                </label>
                <input type="text" id="phoneNumber" class="${properties.kcInputClass!} ${properties.kcFormReadOnlyClass!}"
                       name="phoneNumber" value="${phoneNumber!''}" readonly disabled />
            </div>

            <#-- 验证码输入 -->
            <div class="${properties.kcFormGroupClass!}">
                <label for="verificationCode" class="${properties.kcFormLabelClass!}">
                    <span class="${properties.kcFormLabelTextClass!}">${msg("verificationCode","验证码")}</span>
                    <span class="${properties.kcInputRequiredClass!}">*</span>
                </label>
                <div class="${properties.kcInputGroup!}">
                    <div class="${properties.kcInputGroupItemClass!} ${properties.kcFill!}">
                        <input type="text" id="verificationCode" class="${properties.kcInputClass!}"
                               name="verificationCode" autocomplete="off" autofocus
                               placeholder="${msg('verificationCodePlaceholder','请输入6位验证码')}"
                               maxlength="6"
                               required />
                    </div>
                    <div class="${properties.kcInputGroupItemClass!}">
                        <button type="button" id="sendCodeBtn"
                                class="${properties.kcButtonClass!} ${properties.kcButtonSecondaryClass!}"
                                onclick="sendVerificationCode()">
                            ${msg("sendCode","发送验证码")}
                        </button>
                    </div>
                </div>
                <div class="${properties.kcFormHelperTextClass!}">
                    <div class="${properties.kcInputHelperTextClass!}">
                        <span class="${properties.kcInputHelperTextItemClass!}">
                            <span class="${properties.kcInputHelperTextItemTextClass!}">
                                ${msg("verificationCodeHint","验证码将发送到您的手机，有效期5分钟")}
                            </span>
                        </span>
                    </div>
                </div>
            </div>

            <#-- 提交按钮 -->
            <div id="kc-form-buttons" class="${properties.kcFormActionGroupClass!}">
                <button class="${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!}"
                        type="submit">
                    ${msg("doVerify","验证")}
                </button>
            </div>
        </form>

        <script type="text/javascript">
            var countdown = 60;
            var timer = null;

            function sendVerificationCode() {
                var btn = document.getElementById('sendCodeBtn');

                // 禁用按钮
                btn.disabled = true;
                btn.textContent = '${msg("sending","发送中...")}';

                // 发送请求
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = '${url.loginAction}';

                var actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'sendCode';
                form.appendChild(actionInput);

                document.body.appendChild(form);
                form.submit();

                // 开始倒计时
                startCountdown();
            }

            function startCountdown() {
                var btn = document.getElementById('sendCodeBtn');
                countdown = 60;

                timer = setInterval(function() {
                    countdown--;
                    btn.textContent = countdown + '${msg("secondsRetry","秒后重试")}';

                    if (countdown <= 0) {
                        clearInterval(timer);
                        btn.disabled = false;
                        btn.textContent = '${msg("sendCode","发送验证码")}';
                    }
                }, 1000);
            }

            // 如果页面有消息提示，可能是发送成功，需要处理倒计时
            window.onload = function() {
                var alerts = document.querySelectorAll('.${properties.kcAlertClass!}');
                for (var i = 0; i < alerts.length; i++) {
                    if (alerts[i].textContent.indexOf('${msg("codeSent","验证码已发送")}') !== -1) {
                        // 发送成功，开始倒计时
                        startCountdown();
                        break;
                    }
                }
            };
        </script>
    </#if>
</@layout.registrationLayout>
