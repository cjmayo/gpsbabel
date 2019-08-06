# $Id: app.pro,v 1.19 2010-11-01 03:30:42 robertl Exp $
#

CONFIG += qt
CONFIG(debug, debug|release) {
  CONFIG += console
}

ICON = images/appicon.icns

QT += core \
      gui \
      network \
      xml

qtHaveModule(webenginewidgets) {
  QT += webenginewidgets webchannel
  DEFINES += HAVE_WEBENGINE
} else {
  QT += webkit webkitwidgets 
}

unix:DESTDIR = objects
unix:MOC_DIR = objects
unix:OBJECTS_DIR = objects
unix:RCC_DIR = objects
mac:DESTDIR = .

mac:LIBS += -framework IOKit -framework CoreFoundation
unix {
    CONFIG += link_pkgconfig
    packagesExist(libudev) {
        DEFINES += HAVE_UDEV
        PKGCONFIG += libudev
    }

    # To override the installed location of gmapbase.html set PKGDATADIR.
    # e.g. qmake PKGDATADIR=/usr/share/gpsbabel
    !isEmpty(PKGDATADIR):DEFINES += PKGDATADIR=\\\"$$PKGDATADIR\\\"

    # To override the installed location of the translation files (*.qm)
    # set QTTRANSLATIONDIR.
    # Common use case 1:
    # If the translations are installed local to the package then 
    # gpsbabel_*.qm, gpsbabelfe_*.qm and the concatenated qt_*.qm must all
    # be in QTTRANSLATIONDIR.
    # .e.g. qmake QTTRANSLATIONDIR=/usr/share/gpsbabel/translations
    # Note that the package_app target will create the concatenated qt_*.qm files.
    # The concatenated qt_*.qm files are DIFFERENT from the
    # the Qt provided meta catalog file of the same name, the concatenated
    # qt_*.qm files include all the necessary Qt provided module qm files.
    # Common use case 2:
    # If the translations are installed in the directory that contains all the
    # original Qt provided translations, then only gpsbabel_*.qm and
    # gpsbabelfe_*.qm need be installed alongside the original Qt provided
    # translations (which include the meta catalogs as well as the module
    # qm files.)
    # .e.g. qmake QTTRANSLATIONDIR=/usr/share/qt5/translations
    !isEmpty(QTTRANSLATIONDIR):DEFINES += QTTRANSLATIONDIR=\\\"$$QTTRANSLATIONDIR\\\"
}

UI_DIR = tmp

RESOURCES = app.qrc 
RC_FILE = app.rc

win32 { 
  TARGET=GPSBabelFE
}
win32-g++ {
  QMAKE_LFLAGS_RELEASE += -static-libgcc
}
unix:TARGET=gpsbabelfe
mac:TARGET=GPSBabelFE

FORMS += aboutui.ui
FORMS += advui.ui
FORMS += donate.ui
FORMS += filterui.ui
FORMS += gmapui.ui
FORMS += mainwinui.ui
FORMS += miscfltui.ui
FORMS += preferences.ui
FORMS += rttrkui.ui
FORMS += trackui.ui
FORMS += upgrade.ui
FORMS += version_mismatch.ui
FORMS += wayptsui.ui

SOURCES += aboutdlg.cc
SOURCES += advdlg.cc
SOURCES += donate.cc
SOURCES += dpencode.cc
SOURCES += filterdata.cc
SOURCES += filterdlg.cc
SOURCES += filterwidgets.cc
SOURCES += format.cc
SOURCES += formatload.cc
SOURCES += gmapdlg.cc
SOURCES += gpx.cc
SOURCES += help.cc
SOURCES += latlng.cc
SOURCES += main.cc
SOURCES += mainwindow.cc
SOURCES += map.cc
SOURCES += optionsdlg.cc
SOURCES += preferences.cc
SOURCES += processwait.cc
SOURCES += upgrade.cc
SOURCES += version_mismatch.cc
unix:!mac {
  SOURCES += serial_unix.cc
} else:mac {
  SOURCES += serial_mac.cc
} else:windows {
  SOURCES += serial_win.cc
}

HEADERS += aboutdlg.h
HEADERS += advdlg.h
HEADERS += appname.h
HEADERS += babeldata.h
HEADERS += donate.h
HEADERS += filterdata.h
HEADERS += filterdlg.h
HEADERS += filterwidgets.h
HEADERS += format.h
HEADERS += formatload.h
HEADERS += gmapdlg.h
HEADERS += gpx.h
HEADERS += help.h
HEADERS += mainwindow.h
HEADERS += map.h
HEADERS += optionsdlg.h
HEADERS += preferences.h
HEADERS += processwait.h
HEADERS += setting.h
HEADERS += upgrade.h
HEADERS += version_mismatch.h

TRANSLATIONS += gpsbabelfe_ru.ts
TRANSLATIONS += gpsbabelfe_de.ts
TRANSLATIONS += gpsbabelfe_es.ts
TRANSLATIONS += gpsbabelfe_fr.ts
TRANSLATIONS += gpsbabelfe_hu.ts
TRANSLATIONS += gpsbabelfe_it.ts

macx|linux{
  package.commands = QMAKE=$(QMAKE) ./package_app
  package.depends = $(TARGET)
  QMAKE_EXTRA_TARGETS += package
}
linux: QMAKE_DISTCLEAN += -r GPSBabelFE

# build the compilation data base used by clang tools including clang-tidy,
# as well as CLion.
macx|linux{
  compile_command_database.target = compile_commands.json
  compile_command_database.commands = make clean; bear make
  QMAKE_EXTRA_TARGETS += compile_command_database
  QMAKE_DISTCLEAN += compile_commands.json
}

