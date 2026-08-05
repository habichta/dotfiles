########################################
# web-* page shortcuts (open as a tab via ff)
#
# URLs mirror the Tridactyl bindings in ~/.config/tridactyl/tridactylrc.
# Everything on *.sedimentum.internal needs the VPN — run `vpn up` first.
# Run `web` with no arguments to list every shortcut and its URL.
########################################

# --- Cockpit management console (/mc/, Django admin) -----------------------
alias web-cockpit-dev='ff https://dev-web-01.sedimentum.internal/mc/'
alias web-cockpit-staging='ff https://staging-web-01.sedimentum.internal/mc/'
alias web-cockpit-prod='ff https://prod-web-01.sedimentum.internal/mc/'
alias web-cockpit-local='ff http://localhost:8001/mc/'

# --- Device twin / provisioning services ------------------------------------
alias web-devicetwin='ff https://provisioning-services-01.sedimentum.internal/mc/'
alias web-devicetwin-devices='ff https://provisioning-services-01.sedimentum.internal/mc/core/device/'

# --- Cockpit public frontends ------------------------------------------------
alias web-app-dev='ff https://2989ccfb-3d84-459f-819e-e89af3055cb7.app.helpany.com'
alias web-app-staging='ff https://1bada022-4f23-4ae5-8e65-511ef6080cca.app.helpany.com'
alias web-app-prod='ff https://app.helpany.com'

# --- Customer subscriptions --------------------------------------------------
# NB: these 404 at / in every stage — the app is served on a sub-path.
alias web-subs-dev='ff https://8b14bd1b-ab7b-4c17-ace6-2a9466e57a09.sedimentum.com'
alias web-subs-staging='ff https://7132118e-5e40-409d-978b-6811722e05d9.sedimentum.com'
alias web-subs-prod='ff https://9e0da6c7-4c95-4155-b319-c3f3d4c7dfe5.sedimentum.com'

# --- RabbitMQ management (:15671) -------------------------------------------
alias web-rabbit-dev='ff https://dev-message-broker-01.sedimentum.internal:15671/'
alias web-rabbit-staging='ff https://staging-message-broker-01.sedimentum.internal:15671/'
alias web-rabbit-prod='ff https://prod-message-broker-01.sedimentum.internal:15671/'

# --- Grafana (:3000, general-overview dashboard) -----------------------------
alias web-grafana-dev='ff http://dev-monitoring-01.sedimentum.internal:3000/d/vMnzGmUnz/general-overview'
alias web-grafana-staging='ff http://staging-monitoring-01.sedimentum.internal:3000/d/vMnzGmUnz/general-overview'
alias web-grafana-prod='ff http://prod-monitoring-01.sedimentum.internal:3000/d/vMnzGmUnz/general-overview'
alias web-grafana-common='ff http://common-monitoring-01.sedimentum.internal:3000/d/vMnzGmUnz/general-overview'
alias web-grafana-explore='ff http://prod-monitoring-01.sedimentum.internal:3000/explore'

# --- Loki log explorer (:3000/a/grafana-lokiexplore-app) ---------------------
alias web-grafana-dev-log='ff http://dev-monitoring-01.sedimentum.internal:3000/a/grafana-lokiexplore-app'
alias web-grafana-staging-log='ff http://staging-monitoring-01.sedimentum.internal:3000/a/grafana-lokiexplore-app'
alias web-grafana-prod-log='ff http://prod-monitoring-01.sedimentum.internal:3000/a/grafana-lokiexplore-app'
alias web-grafana-common-log='ff http://common-monitoring-01.sedimentum.internal:3000/a/grafana-lokiexplore-app'

# --- GitHub ------------------------------------------------------------------
alias web-gh='ff https://github.com/'
alias web-gh-org='ff https://github.com/Sedimentum/'
alias web-gh-prs='ff https://github.com/pulls/'
alias web-gh-notifications='ff https://github.com/notifications/'
alias web-gh-infrastructure='ff https://github.com/Sedimentum/Infrastructure'
alias web-gh-cockpit='ff https://github.com/Sedimentum/VigilanceCockpit'
alias web-gh-cockpit-frontend='ff https://github.com/Sedimentum/VigilanceCockpitFrontend'

# --- SharePoint / Atlassian --------------------------------------------------
alias web-sp-engineering='ff https://sedimentum.sharepoint.com/sites/Engineering/'
alias web-sp-operations='ff https://sedimentum.sharepoint.com/sites/Operations/'
alias web-sp-kreditoren='ff "https://sedimentum.sharepoint.com/sites/Operations/Freigegebene%20Dokumente/Forms/AllItems.aspx?newTargetListUrl=%2Fsites%2FOperations%2FFreigegebene%20Dokumente&viewpath=%2Fsites%2FOperations%2FFreigegebene%20Dokumente%2FForms%2FAllItems%2Easpx&id=%2Fsites%2FOperations%2FFreigegebene%20Dokumente%2F01%5FFinance%2F01%5FInbox%2F02%5FKreditoren%5Foffen&viewid=e0bed716%2Dcc01%2D4141%2Db247%2D5ee0bd55a8de"'
alias web-sp-spesen='ff "https://sedimentum.sharepoint.com/sites/Operations/Freigegebene%20Dokumente/Forms/AllItems.aspx?newTargetListUrl=%2Fsites%2FOperations%2FFreigegebene%20Dokumente&viewpath=%2Fsites%2FOperations%2FFreigegebene%20Dokumente%2FForms%2FAllItems%2Easpx&id=%2Fsites%2FOperations%2FFreigegebene%20Dokumente%2F01%5FFinance%2F01%5FInbox%2F06%5FSpesenbelege%5FArthur%5Fprivat%5Fbezahlt&viewid=e0bed716%2Dcc01%2D4141%2Db247%2D5ee0bd55a8de"'
alias web-sp-customers-won='ff "https://sedimentum.sharepoint.com/sites/HelpanyUS/Shared%20Documents/Forms/AllItems.aspx?id=%2Fsites%2FHelpanyUS%2FShared%20Documents%2F04%5FSales%2F01%5FCustomers%2F00%5FWon&viewid=cbb6eb3a%2D4a37%2D41b7%2D9a71%2D26d9f057a9f0&ga=1"'
alias web-jira='ff https://sedimentum.atlassian.net/jira/software/projects/PF/boards/30'

# --- Misc --------------------------------------------------------------------
alias web-jupyter='ff https://jupyter.sedimentum.internal/'
alias web-sentry='ff https://9c3c2492-fc0d-4299-a490-44f068b8fba9.sedimentum.com'
alias web-localhost='ff http://localhost:3000'

# List every web-* shortcut with the URL it opens.
web() {
  local a
  for a in ${(ok)aliases[(I)web-*]}; do
    printf '%-26s %s\n' "$a" "${(Q)${aliases[$a]#ff }}"
  done
}

# TAB completion for ff: offers every web-* target. fzf-tab turns this into a
# searchable picker; the URL is what gets inserted, the alias name is the label.
_ff() {
  # Open fzf on the FIRST Tab. fzf-tab hardcodes an early return that inserts
  # the longest common prefix instead of showing the picker (fzf-tab.zsh:172),
  # which is why `ff <Tab>` used to type "http" — every URL shares it. That
  # branch is skipped when compstate[list] contains "force", so ask for it.
  compstate[list]='force'

  local -a vals descs
  local a u
  for a in ${(ok)aliases[(I)web-*]}; do
    u=${(Q)${aliases[$a]#ff }}
    vals+=("$u")
    descs+=("${(r:28:)a} $u")
  done
  # No -Q: zsh must escape ? and & in the SharePoint URLs, otherwise the shell
  # would glob them / background the command when the completion is inserted.
  _describe -V -t web-targets 'web target' descs vals
}
compdef _ff ff
