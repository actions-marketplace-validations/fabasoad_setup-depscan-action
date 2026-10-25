#!/usr/bin/env sh

SCRIPT_PATH=$(realpath "$0")
SRC_DIR_PATH=$(dirname "$SCRIPT_PATH")
LIB_DIR_PATH="${SRC_DIR_PATH}/lib"

. "${LIB_DIR_PATH}/logging.sh"

main() {
  version="${1}"
  log_info "Installing @cyclonedx/cdxgen via npm..."
  log_debug "npm install -g @cyclonedx/cdxgen"
  npm install -g @cyclonedx/cdxgen
  log_info "Installing owasp-depscan via pip..."
  if [ "${version}" = "latest" ]; then
    log_debug "python -m pip install owasp-depscan --break-system-packages"
    python -m pip install owasp-depscan --break-system-packages
  else
    min_version=$(printf '%s\n' "${version}" "6.3.0" | sort -V | head -n1)
    if [ "${min_version}" != "6.3.0" ]; then
      log_debug "python -m pip install ds-analysis-lib==${version} owasp-depscan==${version} 'appthreat-vulnerability-db<7.0.0' --break-system-packages"
      python -m pip install ds-analysis-lib=="${version}" owasp-depscan=="${version}" "appthreat-vulnerability-db<7.0.0" --break-system-packages
    else
      log_debug "python -m pip install ds-analysis-lib==${version} owasp-depscan==${version} --break-system-packages"
      python -m pip install ds-analysis-lib=="${version}" owasp-depscan=="${version}" --break-system-packages
    fi
  fi
}

main "$@"
