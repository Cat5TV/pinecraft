#!/bin/bash
set -euo pipefail

PC_SEEDS_FILE="${SCRIPT_DIR}/lib/seeds.json"

pc_seed_menu_entries() {
  jq -r '.seeds[] | [.id,.name,.description] | @tsv' "$PC_SEEDS_FILE" | tr '	' '|'
}

pc_seed_get_record() {
  local seed_id="$1"
  jq -r --arg id "$seed_id" '.seeds[] | select(.id==$id) | [.id,.name,.seed,(.versions|join(",")),.policy] | @tsv' "$PC_SEEDS_FILE" | tr '	' '|'
}

pc_seed_expand_versions() {
  local seed_versions_raw="$1"
  local policy="$2"
  shift 2
  local -a versions=("$@")
  local -a seed_specs=()
  local -a matched=()
  local -a ordered=()
  local spec lane v

  if [[ "$seed_versions_raw" == "*" ]]; then
    printf '%s
' "${versions[@]}"
    return 0
  fi

  IFS=',' read -r -a seed_specs <<< "$seed_versions_raw"

  for spec in "${seed_specs[@]}"; do
    matched=()

    if [[ "$spec" == *.x ]]; then
      lane="${spec%.x}"
      for v in "${versions[@]}"; do
        [[ "$v" == ${lane}.* ]] && matched+=("$v")
      done
    else
      for v in "${versions[@]}"; do
        [[ "$v" == "$spec" ]] && matched+=("$v")
      done
    fi

    if [[ ${#matched[@]} -gt 0 ]]; then
      if [[ "$policy" == "highest_patch" ]]; then
        ordered+=("${matched[0]}")
      else
        ordered+=("${matched[@]}")
      fi
    fi
  done

  printf '%s
' "${ordered[@]}" | awk 'NF && !seen[$0]++'
}

pc_seed_filter_versions() {
  local seed_versions_raw="$1"
  local policy="$2"
  shift 2
  local -a versions=("$@")

  pc_seed_expand_versions "$seed_versions_raw" "$policy" "${versions[@]}" | awk 'NF'
}

pc_seed_get_record_by_index() {
  local idx="$1"
  jq -r --argjson idx "$idx" '.seeds[$idx] | [.id,.name,.seed,(.versions|join(",")),.policy] | @tsv' "$PC_SEEDS_FILE" | tr '	' '|'
}


pc_seed_menu_entries_for_flavour() {
  local flavour="$1"
  local -a versions=()
  local seed_id seed_name seed_desc seed_versions seed_policy

  mapfile -t versions < <(pc_provider_list_versions "$flavour" 2>/dev/null || true)

  while IFS='|' read -r seed_id seed_name seed_desc seed_versions seed_policy; do
    if [[ ${#versions[@]} -eq 0 ]]; then
      continue
    fi

    if mapfile -t _pc_seed_matches < <(pc_seed_filter_versions "$seed_versions" "$seed_policy" "${versions[@]}"); then
      if [[ ${#_pc_seed_matches[@]} -gt 0 ]]; then
        printf '%s|%s|%s
' "$seed_id" "$seed_name" "$seed_desc"
      fi
      unset _pc_seed_matches
    fi
  done < <(jq -r '.seeds[] | [.id,.name,.description, (.versions|join(",")), .policy] | @tsv' "$PC_SEEDS_FILE" | tr '	' '|')
}

pc_seed_hidden_count_for_flavour() {
  local flavour="$1"
  local -a versions=()
  local total=0
  local shown=0
  local seed_versions seed_policy

  mapfile -t versions < <(pc_provider_list_versions "$flavour" 2>/dev/null || true)

  while IFS='|' read -r _ _ _ seed_versions seed_policy; do
    total=$((total + 1))
    if [[ ${#versions[@]} -eq 0 ]]; then
      continue
    fi
    if mapfile -t _pc_seed_matches < <(pc_seed_filter_versions "$seed_versions" "$seed_policy" "${versions[@]}"); then
      if [[ ${#_pc_seed_matches[@]} -gt 0 ]]; then
        shown=$((shown + 1))
      fi
      unset _pc_seed_matches
    fi
  done < <(jq -r '.seeds[] | [.id,.name,.description, (.versions|join(",")), .policy] | @tsv' "$PC_SEEDS_FILE" | tr '	' '|')

  echo $(( total - shown ))
}
