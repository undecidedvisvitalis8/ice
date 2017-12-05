# **********************************************************************
#
# Copyright (c) 2003-2013 ZeroC, Inc. All rights reserved.
#
# This copy of Ice is licensed to you under the terms described in the
# ICE_LICENSE file included in this distribution.
#
# **********************************************************************

top_srcdir	= ..\..

PKG		= Glacier2
LIBNAME		= $(PKG).dll
TARGETS		= $(assembliesdir)\$(LIBNAME)
POLICY_TARGET   = $(POLICY).dll

SRCS		= SessionFactoryHelper.cs \
		  SessionHelper.cs \
		  SessionCallback.cs \
		  Application.cs \
		  AssemblyInfo.cs

GEN_SRCS	= $(GDIR)\PermissionsVerifier.cs \
		  $(GDIR)\Router.cs \
		  $(GDIR)\Session.cs \
		  $(GDIR)\SSLInfo.cs \
		  $(GDIR)\Metrics.cs

SDIR		= $(slicedir)\Glacier2
GDIR		= generated

!include $(top_srcdir)/config/Make.rules.mak.cs

MCSFLAGS	= $(MCSFLAGS) -target:library -out:$(TARGETS) -warnaserror-
MCSFLAGS	= $(MCSFLAGS) -keyfile:"$(KEYFILE)"
MCSFLAGS	= $(MCSFLAGS) /doc:$(assembliesdir)\$(PKG).xml /nowarn:1591

# -r:WindowsBase.dll

SLICE2CSFLAGS	= $(SLICE2CSFLAGS) -I$(slicedir) --ice

$(TARGETS):: $(SRCS) $(GEN_SRCS)
	$(MCS) /baseaddress:0x22000000 $(MCSFLAGS) -r:$(refdir)\Ice.dll $(SRCS) $(GEN_SRCS)

!if "$(DEBUG)" == "yes"
clean::
	del /q $(assembliesdir)\$(PKG).pdb
!endif

clean::
	del /q $(assembliesdir)\$(PKG).xml

install:: all
	copy $(assembliesdir)\$(LIBNAME) "$(install_assembliesdir)"
	copy $(assembliesdir)\$(PKG).xml "$(install_assembliesdir)"
!if "$(generate_policies)" == "yes"
	copy $(assembliesdir)\$(POLICY_TARGET) "$(install_assembliesdir)"
!endif
!if "$(DEBUG)" == "yes"
	copy $(assembliesdir)\$(PKG).pdb "$(install_assembliesdir)"
!endif

!include .depend.mak