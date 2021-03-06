Name:           COLLABORATE-Space
Version:        1
Release:        0
Summary:        COLLABORATE Space RPM

Group:          ClearOne
BuildArch:      noarch
License:        MIT
URL:            https://clearone.com
Source0:        COLLABORATE-Space-1.0.tar.gz

%description
COLLABORATE Space

%prep
%setup -q
%build

%install
# Create directory
install -m 0755 -d $RPM_BUILD_ROOT/usr/local/COLLABORATE-Space

install -m 0644 admin.war $RPM_BUILD_ROOT/usr/local/COLLABORATE-Space/admin.war

#0.8.0 - COLLABORATE Space - RPM - DcsWatch - 1811271135
#install -m 0644 java.tar.gz $RPM_BUILD_ROOT/usr/local/COLLABORATE-Space/java.tar.gz

#0.7.0 - COLLABORATE Space - RPM - Tomcat - 181811270949
install -m 0644 apache-tomcat-9.0.13.tar.gz $RPM_BUILD_ROOT/usr/local/COLLABORATE-Space/apache-tomcat-9.0.13.tar.gz
0.8.0 - COLLABORATE Space - RPM - DcsWatch - 1811271135
install -m 0644 repo.tar.gz $RPM_BUILD_ROOT/usr/local/COLLABORATE-Space/repo.tar.gz

%files
/usr/local/COLLABORATE-Space

%changelog
* Mon Nov 19 2018 ClearOne JBG  1.0.0
  - Initial rpm release