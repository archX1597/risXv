set work_path WORK
define_design_lib WORK -path $work_path

set top_design "plru_32"
set slow_library_name "tcbn28hpcplusbwp12t40p140lvtssg0p9v0c_ccs.db"
set fast_library_name {}
set library_path "./lib"

set slow_library "$library_path/$slow_library_name"
set search_path "../src ../src/core ../src/mms ./lib"
set_app_var search_path "$search_path"
set_app_var link_path  *
set_app_var link_library "* $slow_library"
set_app_var target_library "$slow_library"