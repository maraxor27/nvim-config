if !exists("main_syntax")
  " quit when a syntax file was already loaded
  if exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'gn'
elseif exists("b:current_syntax") && b:current_syntax == "gn"
  finish
endif

let s:cpo_save = &cpo
set cpo&vim


syn match gnComment "#.*" contains=@Spell
syn match gnNumber /\v<[0-9]+(\.[0-9]*)?>/
syn keyword gnBoolean true false

syn region gnString start="\"" end="\""

syn match gnIdentifier /[A-Za-z_][A-Za-z0-9_]*/

" syn keyword gnOperator + += == != - -= < <= ! = > >= && || 
syn match gnOperator /\v(\+|\+\=|\=\=|\!\=|\-|\-\=|\<|\<\=|\!|\=|\>|\>\=|\&\&|\|\||\(|\))/

syn keyword gnConditional if else

syn keyword gnFunction action action_foreach bundle_data copy create_bundle executable generated_file group loadable_module rust_library rust_proc_macro shared_library source_set static_library target
syn keyword gnFunction assert config declare_args defined exec_script filter_exclude filter_include filter_labels_exclude filter_labels_include foreach forward_variables_from get_label_info get_path_info get_target_outputs getenv import label_matches not_needed pool print print_stack_trace process_file_template read_file rebase_path set_default_toolchain set_defaults split_list string_join string_replace string_split template tool toolchain write_file

syn keyword gnLanguage current_cpu current_os current_toolchain default_toolchain gn_version host_cpu host_os invoker python_path root_build_dir root_gen_dir root_out_dir target_cpu target_gen_dir target_name target_os target_out_dir
syn keyword gnLanguage aliased_deps all_dependent_configs allow_circular_includes_from arflags args asmflags assert_no_deps bridge_header bundle_contents_dir bundle_deps_filter bundle_executable_dir bundle_resources_dir bundle_root_dir cflags cflags_c cflags_cc cflags_objc cflags_objcc check_includes code_signing_args code_signing_outputs code_signing_script code_signing_sources complete_static_lib configs contents crate_name crate_root crate_type data data_deps data_keys defines depfile deps externs framework_dirs frameworks friend gen_deps include_dirs inputs ldflags lib_dirs libs metadata mnemonic module_name output_conversion output_dir output_extension output_name output_prefix_override outputs partial_info_plist pool post_processing_args post_processing_outputs post_processing_script post_processing_sources precompiled_header precompiled_header_type precompiled_source product_type public public_configs public_deps rebase response_file_contents rustflags script sources swiftflags testonly transparent visibility walk_keys weak_frameworks write_runtime_deps xcasset_compiler_flags xcode_extra_attributes xcode_test_application_name

hi def link gnComment Comment
hi def link gnString String
hi def link gnNumber Number
hi def link gnBoolean Boolean
hi def link gnIdentifier Identifier
hi def link gnOperator Conditional
hi def link gnConditional Conditional
hi def link gnFunction Special
hi def link gnLanguage Special

let b:current_syntax = "gn"
if main_syntax == 'gn'
  unlet main_syntax
endif
let &cpo = s:cpo_save
unlet s:cpo_save

