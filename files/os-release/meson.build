project('eos-build-meta-os-release')

branch_name = get_option('branch')
if branch_name == 'master'
  branch_name = 'Nightly'
endif

vcs_tag = run_command('git', 'rev-parse', '--short', '@', check: false).stdout().strip()

conf_data = configuration_data({
  'SDK_BRANCH': branch_name
})

conf_data.set('ISSUE_NAME', 'Endless OS')
conf_data.set('VARIANT_ID', get_option('variant'))
conf_data.set('IMAGE_VERSION', get_option('image-version'))
conf_data.set('EOS_COMMIT', vcs_tag)
if get_option('variant') == 'devel'
  conf_data.set('VARIANT', 'Development')
  conf_data.set('FULL_NAME', 'Endless OS Development')
elif get_option('variant') == 'user'
  conf_data.set('VARIANT', 'User')
  conf_data.set('FULL_NAME', 'Endless OS')
endif

configure_file(
    input : 'os-release.in',
    output : 'os-release',
    configuration : conf_data,
    install_dir : get_option('prefix') / 'lib'
)

configure_file(
   input : 'issue.net.in',
    output : 'issue.net',
    configuration : conf_data,
    install_dir : get_option('sysconfdir')
)

configure_file(
   input : 'issue.in',
    output : 'issue',
    configuration : conf_data,
    install_dir : get_option('sysconfdir')
)

meson.add_install_script('os-release-symlink.sh', get_option('sysconfdir'))
