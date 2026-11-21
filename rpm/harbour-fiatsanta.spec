Name:       harbour-fiatsanta
Summary:    fiat santa – the family's Secret Santa
Version:    1.0
Release:    1
License:    MIT
URL:        https://github.com/munksh/FiatSanta
Source0:    %{name}-%{version}.tar.bz2
Requires:   sailfishsilica-qt5 >= 0.10.9
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  qt5-qttools-linguist
BuildRequires:  desktop-file-utils

%description
Draws the family's Secret Santa: who gives a present to whom, with pairs
who must not draw each other kept apart both ways and an optional price
limit. Then everyone looks in turn on the one phone, or gets a message
with a code of their own to open on theirs. No account, no network.

%if 0%{?_chum}
Title: fiat santa - secret santa
Type: desktop-application
DeveloperName: Munkstolen
Categories:
 - Utility
AIRating: V
AINote: Claude is my typist - I cross review with Mistral, and add the code once it looks good. Architecture, design, on-device testing, releases and maintenance by me; issues and input welcome.
PackageIcon: https://munkstolen.se/SFOS/harbour-fiatsanta.png
Screenshots:
 - https://munkstolen.se/SFOS/fiatsanta1.png
 - https://munkstolen.se/SFOS/fiatsanta2.png
 - https://munkstolen.se/SFOS/fiatsanta3.png
Custom:
  Repo: https://github.com/munksh/FiatSanta
Links:
  Homepage: https://github.com/munksh/FiatSanta
  Bugtracker: https://github.com/munksh/FiatSanta/issues
%endif

%prep
%setup -q -n %{name}-%{version}

%build
%qmake5 APP_VERSION=%{version}
make %{?_smp_mflags}

%install
rm -rf %{buildroot}
make install INSTALL_ROOT=%{buildroot}

desktop-file-install --delete-original \
  --dir %{buildroot}%{_datadir}/applications \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}/%{name}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png

%changelog
* Sat Nov 21 2026 Caesar Prometheus Ivarsson <caesar@munkstolen.se> - 1.0-1
- First release: names, pairs who must not draw each other, a price limit,
  then pass the phone round or send everyone a code. Codes open in the web
  version of the family's Secret Santa too.
