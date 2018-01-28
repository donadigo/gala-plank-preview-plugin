project ('plank-preview', ['vala', 'c'])

add_project_arguments(['--vapidir', join_paths(meson.current_source_dir(), 'vapi')],
                    language: 'vala')

c_args = [
    '-DWNCK_I_KNOW_THIS_IS_UNSTABLE'
]

deps = [
    dependency ('granite'),
    dependency ('clutter-1.0'),
    dependency ('gala'),
    dependency ('libbamf3'),
    dependency ('libwnck-3.0')
]

lib = shared_library ('plank-preview',
                    'plugin/Main.vala',
                    'plugin/DBusServer.vala',
                    'plugin/WindowPreviewActor.vala',
                    'plugin/ScaledWindowClone.vala',
                    'plugin/ShadowEffect.vala',
                    c_args: c_args,
                    dependencies: deps,
                    install: true,
                    install_dir: join_paths (get_option('libdir'), 'gala', 'plugins'))

meson.add_install_script('meson/post_install.py')