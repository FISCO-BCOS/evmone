# evmone: Fast Ethereum Virtual Machine implementation
# Copyright 2019 Pawel Bylica.
# Licensed under the Apache License, Version 2.0.

# For given target of a static library creates a custom target with -standalone suffix
# that merges the given target and all its static library depenednecies
# into a single static library.
#
# It silently ignores non-static library target and unsupported platforms.
function(merge_static_library TARGET)
    get_target_property(type ${TARGET} TYPE)
    if(NOT type STREQUAL STATIC_LIBRARY)
        return()
    endif()

    if(CMAKE_AR)
        # Generate ar linker script.
        set(script " $<TARGET_FILE:${TARGET}>")
        get_target_property(link_libraries ${TARGET} LINK_LIBRARIES)
        foreach(lib ${link_libraries})
            get_target_property(type ${lib} TYPE)
            if(NOT type STREQUAL INTERFACE_LIBRARY)
                string(APPEND script " $<TARGET_FILE:${lib}>")
            endif()
        endforeach()
        add_custom_command(TARGET ${TARGET} POST_BUILD COMMAND bash -c "${CMAKE_AR} -r ${script}")
    endif()
endfunction()
