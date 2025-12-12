<#macro group name label error="" required=false>

<div class="${properties.kcFormGroupClass}">
    <div class="${properties.kcFormGroupLabelClass}">
        <label for="${name}" class="${properties.kcFormLabelClass}">
        <span class="${properties.kcFormLabelTextClass}">
            ${label}
        </span>
            <#if required>
                <span class="${properties.kcInputRequiredClass}" aria-hidden="true">&#42;</span>
            </#if>
        </label>
    </div>

    <#nested>

    <div id="input-error-container-${name}">
        <#if error?has_content>
            <div class="${properties.kcFormHelperTextClass}" aria-live="polite">
                <div class="${properties.kcInputHelperTextClass}">
                    <div class="${properties.kcInputHelperTextItemClass} ${properties.kcError}" id="input-error-${name}">
                        <span class="${properties.kcInputErrorMessageClass}">
                            ${error}
                        </span>
                    </div>
                </div>
            </div>
        </#if>
    </div>
</div>

</#macro>

<#macro errorIcon error="">
  <#if error?has_content>
    <span class="${properties.kcFormControlUtilClass}">
        <span class="${properties.kcInputErrorIconStatusClass}">
          <i class="${properties.kcInputErrorIconClass}" aria-hidden="true"></i>
        </span>
    </span>
  </#if>
</#macro>

<#macro input name label value="" required=false autocomplete="off" fieldName=name error=kcSanitize(messagesPerField.get(fieldName))?no_esc autofocus=false>
  <@group name=name label=label error=error required=required>
    <span class="${properties.kcInputClass} <#if error?has_content>${properties.kcError}</#if>">
        <input id="${name}" name="${name}" value="${value}" type="text" autocomplete="${autocomplete}"
                placeholder="${msg('enter')}${label}" <#if autofocus>autofocus</#if>
                <#if autocomplete == "one-time-code">inputmode="numeric"</#if>
                aria-invalid="<#if error?has_content>true</#if>"/>
        <@errorIcon error=error/>
    </span>
  </@group>
</#macro>

<#macro password name label value="" required=false forgotPassword=false fieldName=name error=kcSanitize(messagesPerField.get(fieldName))?no_esc autocomplete="off" autofocus=false>
  <@group name=name label=label error=error required=required>
    <#-- 密码输入组:输入框和可见性切换按钮 -->
    <div class="password-input-group" style="position: relative !important; display: block !important; width: 100% !important;">
      <input id="${name}" name="${name}" value="${value}" type="password"
             class="password-input <#if error?has_content>error</#if>"
             placeholder="${msg('enter')}${label}"
             style="width: 100% !important; height: 3rem !important; padding: 0 3.5rem 0 1rem !important; display: block !important; margin: 0 !important; font-size: 1rem; line-height: 1.5; color: var(--input-text); background-color: var(--input-bg); border: 1px solid var(--border-color); border-radius: var(--radius-md); box-shadow: none; outline: none;"
             autocomplete="${autocomplete}" <#if autofocus>autofocus</#if>
             aria-invalid="<#if error?has_content>true</#if>"
             onfocus="this.style.borderColor='var(--border-focus-color)'; this.style.boxShadow='0 0 0 3px rgba(0, 102, 204, 0.1)';"
             onblur="this.style.borderColor='var(--border-color)'; this.style.boxShadow='none';"/>
      <button class="password-visibility-btn" type="button" aria-label="${msg('showPassword')}"
              style="position: absolute !important; right: 0.25rem !important; top: 50% !important; transform: translateY(-50%) !important; width: 2.5rem !important; height: 2.5rem !important; padding: 0.5rem !important; margin: 0 !important; background-color: transparent !important; border: none !important; border-radius: var(--radius-md) !important; cursor: pointer; color: #6b7280 !important; display: flex !important; align-items: center !important; justify-content: center !important; z-index: 10 !important; transition: all 0.2s ease; pointer-events: auto !important;"
              onmouseover="this.style.backgroundColor='#f3f4f6'; this.style.color='var(--primary-color)';"
              onmouseout="this.style.backgroundColor='transparent'; this.style.color='#6b7280';"
              aria-controls="${name}" data-password-toggle tabindex="-1"
              data-icon-show="${properties.kcFormPasswordVisibilityIconShow}"
              data-icon-hide="${properties.kcFormPasswordVisibilityIconHide}"
              data-label-show="${msg('showPassword')}"
              data-label-hide="${msg('hidePassword')}"
              id="${name}-show-password">
          <i class="${properties.kcFormPasswordVisibilityIconShow}" aria-hidden="true"></i>
      </button>
    </div>

    <#-- Helper text 区域:忘记密码链接等 -->
    <div class="${properties.kcFormHelperTextClass}" aria-live="polite" style="margin: 0; padding: 0;">
        <div class="${properties.kcInputHelperTextClass}" style="display: flex; align-items: center; justify-content: space-between; gap: 0.75rem; flex-wrap: wrap; margin: 0; padding: 0;">
            <div style="display: flex; align-items: center; gap: 0.35rem; flex: 1; min-width: 0; margin: 0; padding: 0;">
                <#-- Additional helper items -->
                <#nested>
            </div>
            <#if forgotPassword>
                <div class="${properties.kcInputHelperTextItemClass}" style="margin-left: auto; display: flex; align-items: center; margin: 0; padding: 0;">
                  <span class="${properties.kcInputHelperTextItemTextClass}">
                      <a href="${url.loginResetCredentialsUrl}">${msg("doForgotPassword")}</a>
                  </span>
                </div>
            </#if>
        </div>
    </div>
  </@group>
</#macro>

<#macro clipboard name label ariaLabel=label value="" readonly=true>
  <@group name=name label=label>
    <div class="${properties.kcCodeClipboardCopyClass}" id="kc-${name}-clipboard">
      <div class="${properties.kcCodeClipboardCopyGroupClass}">
        <div class="${properties.kcInputGroup}">
          <div class="${properties.kcInputGroupItemClass}">
            <button 
              class="${properties.kcFormPasswordVisibilityButtonClass}" 
              type="button" 
              aria-label="${msg("code-clipboard-label")}"
              aria-expanded="false"
              aria-controls="kc-${name}-content"
              data-icon-expanded-class="${properties.kcAngleDownIconClass}"
              data-icon-collapsed-class="${properties.kcAngleRightIconClass}"
              data-expanded-class="${properties.kcExpandedClass}"
              id="kc-${name}-toggle"
            >
              <i id="kc-${name}-toggle-icon" class="${properties.kcAngleRightIconClass}" aria-hidden="true"></i>
            </button>
          </div>
          <div class="${properties.kcInputGroupItemClass} ${properties.kcFill}">
            <span class="${properties.kcInputClass} <#if readonly>${properties.kcFormReadOnlyClass}</#if>">
              <input
                id="${name}"
                name="${name}"
                value="${value}"
                type="text"
                <#if readonly>readonly</#if>
                aria-label="${ariaLabel}"
              />
            </span>
          </div>
          <div class="${properties.kcInputGroupItemClass}">
            <button
              class="${properties.kcFormPasswordVisibilityButtonClass}"
              type="button"
              aria-label="${msg("code-copy-label")}"
              data-icon-success="${properties.kcCheckIconClass}"
              data-icon-failure="${properties.kcInputErrorIconClass}"
              data-success-label="${msg("code-copy-success")}"
              data-failure-label="${msg("code-copy-failure")}"
              id="kc-${name}-copy-button"
            >
              <i id="kc-${name}-copy-icon" class="${properties.kcCopyIconClass}" aria-hidden="true"></i>
            </button>
          </div>
        </div>
      </div>
      <div class="${properties.kcCodeClipboardCopyContentClass}" id="kc-${name}-content" hidden>
        <pre><code aria-label="${ariaLabel}">${value}</code></pre>
      </div>
    </div>
  </@group>
</#macro>

<#macro checkbox name label value=false required=false>
  <div class="${properties.kcCheckboxClass}" style="display: flex; align-items: center; gap: 0.35rem; margin: 0;">
    <label for="${name}" class="${properties.kcCheckboxClass}" style="display: flex; align-items: center; gap: 0.35rem; margin: 0; line-height: 1.2;">
      <input
        class="${properties.kcCheckboxInputClass}"
        type="checkbox"
        id="${name}"
        name="${name}"
        style="margin: 0;"
        <#if value>checked</#if>
      />
      <span class="${properties.kcCheckboxLabelClass}">${label}</span>
      <#if required>
        <span class="${properties.kcCheckboxLabelRequiredClass}" aria-hidden="true">&#42;</span>
      </#if>
    </label>
  </div>
</#macro>
