Name:           COLLABORATE Space
Version:        1
Release:        0
Summary:        COLLABORATE Space RPM

Group:          ClearOne
BuildArch:      noarch
License:        MIT
URL:            https://clearone.com
Source0:        COLLABORATE-Space-1.0.tar.gz

%description
Description

%prep
%setup -q
%build
%install
# Create directory
install -m 0755 -d $RPM_BUILD_ROOT/usr/local/COLLABORATE-Space
install -m 0644 admin.war $RPM_BUILD_ROOT/usr/local/COLLABORATE-Space/admin.war

%files
/usr/local/COLLABORATE-Space

%changelog
* 19/11/2018 ClearOne JBG  1.0.0
  - Initial rpm release