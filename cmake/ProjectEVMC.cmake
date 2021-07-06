include(ExternalProject)
include(GNUInstallDirs)

if(NOT EVMC_ROOT)
        ExternalProject_Add(evmc_project
        PREFIX ${CMAKE_SOURCE_DIR}/deps
        DOWNLOAD_NO_PROGRESS 1
        DOWNLOAD_NAME evmc-e0bd9d5d.tar.gz
        URL https://${URL_BASE}/FISCO-BCOS/evmc/archive/e0bd9d5dc68ec3a00fe9a3c5e81c98946449a20d.tar.gz
        URL_HASH SHA256=a9983643415c8473cd696ff4aa93e014308f0292057bce740bc0b4ca84a40462
        CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR> -DHUNTER_USE_CACHE_SERVERS=NO
        # BUILD_COMMAND cmake --build . -- -j
        BUILD_IN_SOURCE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_INSTALL 1
        BUILD_BYPRODUCTS <INSTALL_DIR>/lib/libevmc-instructions.a <INSTALL_DIR>/lib/libevmc-loader.a)
        ExternalProject_Get_Property(evmc_project INSTALL_DIR)
        set(EVMC_INCLUDE_DIRS ${INSTALL_DIR}/include)
        file(MAKE_DIRECTORY ${EVMC_INCLUDE_DIRS})  # Must exist.
        add_library(evmc::loader STATIC IMPORTED)
        set(EVMC_LOADER_LIBRARIES ${INSTALL_DIR}/lib/libevmc-loader.a)
        set_property(TARGET evmc::loader PROPERTY IMPORTED_LOCATION ${EVMC_LOADER_LIBRARIES})
        set_property(TARGET evmc::loader PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${EVMC_INCLUDE_DIRS})

        add_library(evmc::instructions STATIC IMPORTED)
        set(EVMC_INSTRUCTIONS_LIBRARIES ${INSTALL_DIR}/lib/libevmc-instructions.a)
        set_property(TARGET evmc::instructions PROPERTY IMPORTED_LOCATION ${EVMC_INSTRUCTIONS_LIBRARIES})
        set_property(TARGET evmc::instructions PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${EVMC_INCLUDE_DIRS})
else()
        set(EVMC_INCLUDE_DIRS ${EVMC_ROOT}/include)
        set(EVMC_LOADER_LIBRARIES ${EVMC_ROOT}/lib/libevmc-loader.a)
        set(EVMC_INSTRUCTIONS_LIBRARIES ${EVMC_ROOT}/lib/libevmc-instructions.a)
endif()

add_library(evmc INTERFACE IMPORTED)
set_property(TARGET evmc PROPERTY IMPORTED_LOCATION ${EVMC_INSTRUCTIONS_LIBRARIES} ${EVMC_LOADER_LIBRARIES})
set_property(TARGET evmc PROPERTY INTERFACE_INCLUDE_DIRECTORIES ${EVMC_INCLUDE_DIRS})
add_dependencies(evmc evmc_project)
