
# Define a variable to story the name of the target
set(TARGET_NAME libPrinter)

# Add target to the list of exports for the module
install(TARGETS ${TARGET_NAME}
    
    # Export target identifier
    EXPORT ${TARGET_NAME}_EXPORT

    # Install Destination for libraries (*.so)
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}

    # Install Destination for archives (*.a)
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

# Install the exported target
#   - Creates libPrinterTargets.cmake
install(EXPORT ${TARGET_NAME}_EXPORT # Export ID as defined above
    
    # Name of cmake import script
    FILE libPrinterTargets.cmake
    
    # Namespace to create target under
    NAMESPACE Printer::

    # Directory to place the install script in
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/libPrinter
)