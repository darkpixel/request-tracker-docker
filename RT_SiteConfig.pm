use utf8;

# Set($SendmailPath , "/opt/rt5/etc/msmtp_wrapper");
Set($SendmailPath , "/usr/local/bin/msmtp-sendmail.sh");
Set($LogToScreen, 'info');

Set($DatabaseType, "Pg");
Set($DatabaseHost,   "${DATABASE_HOST}");
Set($DatabasePort, "${DATABASE_PORT}");
Set($DatabaseUser, "${DATABASE_USER}");
Set($DatabasePassword, q{${DATABASE_PASSWORD}});
Set($DatabaseName, q{${DATABASE_NAME}});
Set(%DatabaseExtraDSN, sslmode => 'require' );

Set($rtname, '${RT_NAME}');
Set($OwnerEmail, '${OWNER_EMAIL}');
Set($Organization, '${RT_NAME}');
Set($WebDomain, '${WEB_DOMAIN}');
Set($Timezone, '${TIMEZONE}');
Set($WebPort, '${WEB_PORT}');
Set($WebBase, '${WEB_URL}');
Set($WebBaseURL, '${WEB_BASE_URL}');
#Set($WebSecureCookies, 1);
Set($CanonicalizeRedirectURLs, 1);
Set($CorrespondAddress, '${CORRESPOND_ADDRESS}');
Set($CommentAddress, '${COMMENT_ADDRESS}');
Set($TimeInICal, 1);
Set($ShowUnreadMessageNotifications, 1);
Set($ParseNewMessageForTicketCcs, 1);
Set($SquelchList, $ENV{'EMAIL_SQUELCH_LIST'});


Set($HTMLFormatter, 'w3m');

Set($LogoURL, '${LOGO_URL}');
Set($LogoLinkURL, '${LOGO_LINK_URL}');

Set( %FullTextSearch,
    Enable     => 1,
    Indexed    => 0,
    Column     => 'ContentIndex',
    Table      => 'Attachments',
);

# Plugin('RT::Extension::ActivityReports');
# Plugin('RT::Extension::AdminConditionsAndActions');

#Plugin('RT::Extension::Announce');
#Set(@CustomFieldValuesSources, (qw(RT::CustomFieldValues::AnnounceGroups)));

Plugin('RT::Extension::Gravatar');
Plugin('RT::Extension::MergeUsers');
Plugin('RT::IR');
#Plugin('RT::Extension::QuickAssign');
#Plugin('RT::Extension::RepeatTicket');
#Plugin('RT::Extension::RepliesToResolved');
#Plugin('RT::Extension::ResetPassword');
#Plugin('RT::Extension::REST2');
##Plugin('RT::Extension::TicketLocking');
#Plugin('RT::Extension::BounceEmail');
#Plugin('RT::Action::SetPriorityFromHeader');

Set($PriorityHeader, 'X-Priority');
Set(%PriorityMap, highest => 1, high => 2, normal => 3, low => 4, lowest => 5);

Set( $LockExpiry, 5*60 );
Set($HomepageComponents, [qw(
    MyLocks
    MyReminders
    QueueList
    Dashboards
    FindUser
    SavedSearches
    QuickCreate
    RefreshHomepage
)]);

Set(%ServiceAgreements,
    AssumeOutsideActor => 1,
    Default => 'normal',
    QueueDefault => {
        'emergency' => 'emergency',
    },
    Levels => {
        'emergency'  => {
          StartImmediately => 1,
          Response => { RealMinutes => 15 },
          KeepInLoop => { RealMinutes => 30 },
          Resolve  => { RealMinutes => 60*4 },
        },
        'normal'  => {
          Response => { BusinessMinutes => 60*8 },
          Resolve => { BusinessMinutes => 60*24*7 },
        },
        'maintenance' => {
          Response => { BusinessMinutes => 60*24*7 },
          Response => { BusinessMinutes => 60*24*30 },
        },
    },
);

Set(%ServiceBusinessHours,
    'standard' => {
        0 => { Name => 'Sunday', Start => 'undef', End => 'undef' },
        1 => { Name => 'Monday', Start => '7:00', End => '18:00' },
        2 => { Name => 'Tuesday', Start => '7:00', End => '18:00' },
        3 => { Name => 'Wednesday', Start => '7:00', End => '18:00' },
        4 => { Name => 'Thursday', Start => '7:00', End => '18:00' },
        5 => { Name => 'Friday', Start => '7:00', End => '15:00' },
        6 => { Name => 'Saturday', Start => 'undef', End => 'undef' },
    },
);

Set(%Lifecycles,
    default => {
        initial         => [qw(new)], # loc_qw
        active          => [qw(open scheduled on-hold)], # loc_qw
        inactive        => [qw(closed rejected deleted)], # loc_qw

        defaults => {
            on_create => 'new',
            on_merge  => 'closed',
            approved  => 'open',
            denied    => 'rejected',
            reminder_on_open     => 'open',
            reminder_on_resolve  => 'closed',
        },
        transitions => {
            ''                  => [qw(new open scheduled on-hold closed rejected deleted)],
            'new'               => [qw(    open scheduled on-hold closed rejected deleted)],
            'open'              => [qw(new      scheduled on-hold closed rejected deleted)],
            'scheduled'         => [qw(new open           on-hold closed rejected deleted)],
            'on-hold'           => [qw(new open scheduled         closed rejected deleted)],
            'closed'            => [qw(new open scheduled on-hold        rejected deleted)],
            'rejected'          => [qw(new open scheduled on-hold closed          deleted)],
            'deleted'           => [qw(new open scheduled on-hold closed rejected        )],
        },
        rights => {
            '* -> deleted'  => 'DeleteTicket',
            '* -> *'        => 'ModifyTicket',
        },
        actions => [
            'new -> open'                   => { label  => 'Take',                 update => 'Respond' }, # loc{label}
            'new -> closed'                 => { label  => 'Close',                update => 'Respond' }, # loc{label}
            'new -> deleted'                => { label  => 'Delete',                                   }, # loc{label}
            'new -> rejected'               => { label  => 'Reject',               update => 'Respond' }, # loc{label}
            'open -> closed'                => { label  => 'Close',                update => 'Respond' }, # loc{label}
            'open -> on-hold'               => { label  => 'Hold',                 update => 'Respond' }, # loc{label}
            'closed -> open'                => { label  => 'Re-open',              update => 'Respond' }, # loc{label}
            'deleted -> open'               => { label  => 'Undelete',                                 }, # loc{label}
        ],
    },
    assets => {
        type     => "asset",
        initial  => [
            'new'
        ],
        active   => [
            'allocated',
            'in-use',
            'bone-yard'
        ],
        inactive => [
            'dead',
            'recycled',
            'stolen',
            'deleted',
            'destroyed',
            'rma'
        ],

        defaults => {
            on_create => 'new',
        },

        transitions => {
            ''         => [qw(new allocated in-use rma dead)],
            new        => [qw(allocated in-use stolen bone-yard rma dead)],
            allocated  => [qw(in-use recycled stolen destroyed bone-yard rma dead)],
            "in-use"   => [qw(allocated recycled stolen bone-yard rma dead)],
            recycled   => [qw(allocated bone-yard rma dead)],
            destroyed  => [qw(deleted)],
            stolen     => [qw(deleted)],
            rma        => [qw(deleted)],
            dead       => [qw(deleted)],
        },
        rights => {
            '* -> *'        => 'ModifyAsset',
        },
        actions => {
            '* -> allocated' => {
                label => "Allocate"
            },
            '* -> in-use'    => {
                label => "Now in-use"
            },
            '* -> bone-yard'  => {
                label => "Bone Yard"
            },
            '* -> stolen'    => {
                label => "Report stolen"
            },
            '* -> destroyed'    => {
                label => "Destroyed"
            },
            '* -> rma'    => {
                label => "RMAd"
            },
        },
    },
);

1;

