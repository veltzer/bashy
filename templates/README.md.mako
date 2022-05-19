<%!
    import pydmt.helpers.project
    import pydmt.helpers.misc
    import pydmt.helpers.signature
    import config.project
    import user.personal
    line = "=" * len(pydmt.helpers.project.get_name())
%>${pydmt.helpers.project.get_name()}
${line}

version: ${pydmt.helpers.misc.get_version_str()}

description: ${config.project.description_short}

% if hasattr(config.project, "description_long"):
${config.project.description_long}
% endif

	${user.personal.origin}, ${pydmt.helpers.signature.get_copyright_years_long()}
