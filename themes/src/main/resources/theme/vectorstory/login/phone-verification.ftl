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
                <div class="verification-code-input-group" style="position: relative !important; display: block !important; width: 100% !important;">
                    <input type="text" id="verificationCode" class="verification-code-input"
                           style="width: 100% !important; height: 3rem !important; padding: 0 8rem 0 1rem !important; font-size: 1rem; line-height: 1.5; color: var(--input-text); background-color: var(--input-bg); border: 1px solid var(--border-color); border-radius: var(--radius-md); box-shadow: none; outline: none;"
                           name="verificationCode" autocomplete="off" autofocus
                           placeholder="${msg('verificationCodePlaceholder','请输入6位验证码')}"
                           maxlength="6"
                           required
                           onfocus="this.style.borderColor='var(--border-focus-color)'; this.style.boxShadow='0 0 0 3px rgba(0, 102, 204, 0.1)';"
                           onblur="this.style.borderColor='var(--border-color)'; this.style.boxShadow='none';" />
                    <button type="button" id="sendCodeBtn"
                            class="send-code-btn"
                            style="position: absolute !important; right: 0.25rem !important; top: 50% !important; transform: translateY(-50%) !important; height: 2.5rem !important; padding: 0 1rem !important; margin: 0 !important; font-size: 0.875rem; background-color: var(--primary-color); color: white; border: none !important; border-radius: var(--radius-md); cursor: pointer; white-space: nowrap; transition: all 0.2s ease; z-index: 10 !important;"
                            onmouseover="if(!this.disabled) this.style.backgroundColor='var(--primary-hover)';"
                            onmouseout="if(!this.disabled) this.style.backgroundColor='var(--primary-color)';"
                            onclick="sendVerificationCode()">
                        ${msg("sendCode","发送验证码")}
                    </button>
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
            var STORAGE_KEY = 'phone_verification_countdown';
            var STORAGE_TIME_KEY = 'phone_verification_time';

            function sendVerificationCode() {
                var btn = document.getElementById('sendCodeBtn');

                // 禁用按钮
                btn.disabled = true;
                btn.textContent = '${msg("sending","发送中...")}';

                // 保存发送时间到 sessionStorage
                sessionStorage.setItem(STORAGE_TIME_KEY, Date.now().toString());
                sessionStorage.setItem(STORAGE_KEY, '60');

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
            }

            function startCountdown(initialCount) {
                var btn = document.getElementById('sendCodeBtn');
                countdown = initialCount || 60;

                // 清除旧的定时器
                if (timer) {
                    clearInterval(timer);
                }

                btn.disabled = true;

                timer = setInterval(function() {
                    countdown--;
                    sessionStorage.setItem(STORAGE_KEY, countdown.toString());

                    if (countdown > 0) {
                        btn.textContent = countdown + '${msg("secondsRetry","秒后重试")}';
                    } else {
                        clearInterval(timer);
                        btn.disabled = false;
                        btn.textContent = '${msg("sendCode","发送验证码")}';
                        sessionStorage.removeItem(STORAGE_KEY);
                        sessionStorage.removeItem(STORAGE_TIME_KEY);
                    }
                }, 1000);
            }

            // 页面加载时检查是否有未完成的倒计时
            window.onload = function() {
                var savedTime = sessionStorage.getItem(STORAGE_TIME_KEY);
                var savedCount = sessionStorage.getItem(STORAGE_KEY);

                if (savedTime && savedCount) {
                    var elapsed = Math.floor((Date.now() - parseInt(savedTime)) / 1000);
                    var remaining = parseInt(savedCount) - elapsed;

                    if (remaining > 0) {
                        // 继续倒计时
                        startCountdown(remaining);
                    } else {
                        // 倒计时已结束
                        sessionStorage.removeItem(STORAGE_KEY);
                        sessionStorage.removeItem(STORAGE_TIME_KEY);
                    }
                }

                // 检查是否有成功消息
                var alerts = document.querySelectorAll('.pf-v5-c-alert, .alert');
                for (var i = 0; i < alerts.length; i++) {
                    var alertText = alerts[i].textContent || alerts[i].innerText;
                    if (alertText && (alertText.indexOf('验证码已发送') !== -1 ||
                        alertText.indexOf('已发送') !== -1 ||
                        alertText.indexOf('发送成功') !== -1)) {
                        // 如果还没开始倒计时，则开始
                        if (!timer) {
                            sessionStorage.setItem(STORAGE_TIME_KEY, Date.now().toString());
                            sessionStorage.setItem(STORAGE_KEY, '60');
                            startCountdown(60);
                        }
                        break;
                    }
                }
            };
        </script>
    </#if>
</@layout.registrationLayout>
