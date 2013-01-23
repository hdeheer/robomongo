
! include( ../common.pri ) {
    error( Error: couldnt find the common.pri file. )
}

# This specifies the name of the target file.
# It will produce an executable named robomongo on unix and robomongo.exe on windows.
TARGET   = robomongo

TEMPLATE = app

SOURCES += main.cpp
        
INCLUDEPATH += $$SRC_ROOT

win32:LIBS += -lws2_32 -lkernel32 -ladvapi32 -lpsapi -ldbghelp -lpcrecpp \
              -luser32 -lgdi32 -lwinspool -lcomdlg32 \
              -lshell32 -lole32 -loleaut32 -lodbc32 -lodbccp32 -luuid

LIBS += -lgui -lcore -lshell -lqjson -lmongoclient \
        -lboost_thread -lboost_filesystem -lboost_system \
        -lqscintilla2 -ljs

RESOURCES += ../gui/resources/gui.qrc
win32:RC_FILE    = ../gui/resources/win.rc

# This forces the relink when building target
# http://stackoverflow.com/questions/1485435/force-relink-when-building-in-qt-creator
unix:PRE_TARGETDEPS += $$OUTPUT_ROOT/core/out/libcore.a
unix:PRE_TARGETDEPS += $$OUTPUT_ROOT/gui/out/libgui.a
unix:PRE_TARGETDEPS += $$OUTPUT_ROOT/shell/out/libshell.a
win32:PRE_TARGETDEPS += $$OUTPUT_ROOT/core/out/core.lib
win32:PRE_TARGETDEPS += $$OUTPUT_ROOT/gui/out/gui.lib
win32:PRE_TARGETDEPS += $$OUTPUT_ROOT/shell/out/shell.lib

#win32:QMAKE_CFLAGS_DEBUG = -MTd
#win32:QMAKE_CXXFLAGS_DEBUG = -MTd
#win32:QMAKE_LFLAGS_DEBUG = /NODEFAULTLIB:MSVCPRTD /NODEFAULTLIB:MSVCRTD
#win32:QMAKE_LFLAGS_DEBUG =  /NODEFAULTLIB:LIBCMTD /NODEFAULTLIB:MSVCPRTD

win32 {
    contains(QMAKE_HOST.arch, x86_64) {

    } else {
        # Copy qjson.dll to app/out folder
        QMAKE_POST_LINK += $$quote(xcopy /Y \"$$THIRDPARTY_LIBS_PATH\\qjson\\qjson.dll\" \"$$OUT_PWD\\out\" $$escape_expand(\\n))

        # Copy qscintilla2.dll app/out folder
        QMAKE_POST_LINK += $$quote(xcopy /Y \"$$THIRDPARTY_LIBS_PATH\\qscintilla\\qscintilla2.dll\" \"$$OUT_PWD\\out\" $$escape_expand(\\n))
    }
}

unix {
    contains(QMAKE_HOST.arch, x86_64) {
        # Copy qjson to to app/out folder
        QMAKE_POST_LINK += $$quote(cp \"$$THIRDPARTY_LIBS_PATH/qjson/libqjson.so\" \"$$OUT_PWD/out\" $$escape_expand(\\n\\t))
        QMAKE_POST_LINK += $$quote(cp \"$$THIRDPARTY_LIBS_PATH/qjson/libqjson.so.0\" \"$$OUT_PWD/out\" $$escape_expand(\\n\\t))
        QMAKE_POST_LINK += $$quote(cp \"$$THIRDPARTY_LIBS_PATH/qjson/libqjson.so.0.7.1\" \"$$OUT_PWD/out\" $$escape_expand(\\n\\t))

        # Copy qscintilla to app/out folder
        QMAKE_POST_LINK += $$quote(cp \"$$THIRDPARTY_LIBS_PATH/qscintilla/libqscintilla2.so\" \"$$OUT_PWD/out\" $$escape_expand(\\n\\t))
        QMAKE_POST_LINK += $$quote(cp \"$$THIRDPARTY_LIBS_PATH/qscintilla/libqscintilla2.so.8\" \"$$OUT_PWD/out\" $$escape_expand(\\n\\t))
        QMAKE_POST_LINK += $$quote(cp \"$$THIRDPARTY_LIBS_PATH/qscintilla/libqscintilla2.so.8.0\" \"$$OUT_PWD/out\" $$escape_expand(\\n\\t))
        QMAKE_POST_LINK += $$quote(cp \"$$THIRDPARTY_LIBS_PATH/qscintilla/libqscintilla2.so.8.0.2\" \"$$OUT_PWD/out\" $$escape_expand(\\n\\t))

    } else {

    }

    QMAKE_POST_LINK += $$quote(cp \"$$ROOT/build/linux/run.sh\" \"$$OUT_PWD/out\" $$escape_expand(\\n\\t))
    QMAKE_POST_LINK += $$quote(chmod u+x \"$$OUT_PWD/out/run.sh\" $$escape_expand(\\n\\t))
}











