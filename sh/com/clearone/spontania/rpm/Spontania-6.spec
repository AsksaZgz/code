%global debug_package %{nil} 
Summary: Spontania Appliance
Name: Spontania
Version: 6
Release: 0
Source0: Spontania-6.tar.gz
License: Spontania
Group: Applications/Videoconferencing
BuildArch: i386
BuildRoot: %{_tmppath}/%{name}-buildroot
%description
Spontania Appliance
%prep
%setup -q
%build
%install
# rpm 004 ######################################################################
# Delete last version 
rm -f /home/build/rpmbuild/RPMS/i386/Spontania-6-0.i386.rpm
rm -f /home/build/rpmbuild/SRPMS/Spontania-6-0.src.rpm
# rpm 004 ######################################################################/

install -m 0755 -d $RPM_BUILD_ROOT/usr/local/Spontania/bin
install -m 0755 -d $RPM_BUILD_ROOT/usr/local/Spontania/lib
install -m 0755 -d $RPM_BUILD_ROOT/usr/local/Spontania/license
install -m 0755 -d $RPM_BUILD_ROOT/usr/local/Spontania/server
install -m 0755 -d $RPM_BUILD_ROOT/usr/local/Spontania/temp

install -m 0755 scripts/* $RPM_BUILD_ROOT/usr/local/Spontania/bin
install -m 0755 lib/* $RPM_BUILD_ROOT/usr/local/Spontania/lib
install -m 0755 license/* $RPM_BUILD_ROOT/usr/local/Spontania/license
install -m 0755 server/* $RPM_BUILD_ROOT/usr/local/Spontania/server

install -m 0755 SpontaniaWeb6.tar.gz $RPM_BUILD_ROOT/usr/local/Spontania/temp

# rpm 003
# Amazon credential	
install -m 0755 -d $RPM_BUILD_ROOT/usr/local/Spontania/aws		
install -m 0755 aws/* $RPM_BUILD_ROOT/usr/local/Spontania/aws
# /rpm 003


%clean
rm -rf $RPM_BUILD_ROOT
%post
echo " "
echo "Now you need to run spontania_setup.sh in /usr/local/Spontania/bin"
%files
/usr/local/Spontania/aws
/usr/local/Spontania/bin
/usr/local/Spontania/lib
/usr/local/Spontania/temp
/usr/local/Spontania/license
/usr/local/Spontania/server


#%dir /usr/local/Spontania/bin
#cat /usr/local/Spontania/bin/snmpd.conf
