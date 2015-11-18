# Devise
INVITATION_LIMIT = 5

# Date Ranges
DATE_RANGE_THIS_WEEK = (Time.zone.now.to_date.beginning_of_week(:sunday).in_time_zone)..((Time.zone.now.to_date.beginning_of_week(:sunday)+6).in_time_zone.end_of_day)
DATE_RANGE_THIS_MONTH = (Time.zone.now.to_date.at_beginning_of_month.in_time_zone)..((Time.zone.now.to_date.at_end_of_month).in_time_zone.end_of_day)
DATE_RANGE_THIS_YEAR = (Time.zone.now.to_date.at_beginning_of_year.in_time_zone)..((Time.zone.now.to_date.at_end_of_year).in_time_zone.end_of_day)
DATE_RANGE_LAST_WEEK = ((Time.zone.now.to_date.beginning_of_week(:sunday)-7).in_time_zone)..((Time.zone.now.to_date.beginning_of_week(:sunday)-1).in_time_zone.end_of_day)
DATE_RANGE_LAST_MONTH = (Time.zone.now.to_date.last_month.at_beginning_of_month.in_time_zone)..(Time.zone.now.to_date.last_month.at_end_of_month.in_time_zone.end_of_day)
DATE_RANGE_LAST_YEAR = (Time.zone.now.to_date.last_year.at_beginning_of_year.in_time_zone)..(Time.zone.now.to_date.last_year.at_end_of_year.in_time_zone.end_of_day)

# Capture Settings
DEFAULT_CAPTURE_SCREEN = "Mood"
DEFAULT_CAPTURE_DATE = Time.zone.now.to_date
MAX_MOOD_ENTRIES = 3
MAX_SLEEP_ENTRIES = 1
MAX_SELF_CARE_ENTRIES = 1
MAX_JOURNAL_ENTRIES = 1

# Review Chart Settings
DEFAULT_LOOKBACK_PERIOD = 'week'

MOOD_PRIMARY_COLOR = "#27ae60"
MOOD_BACKGROUND_COLOR = "#fff"
MOOD_STROKE_WIDTH = 0
MOOD_ANIMATION_DURATION = 1000
MOOD_ANIMATION_EASING = 'in'
MOOD_LEGEND_POSITION = 'none'

SLEEP_PRIMARY_COLOR = "#2980b9"
SLEEP_BACKGROUND_COLOR = "#fff"
SLEEP_STROKE_WIDTH = 0
SLEEP_ANIMATION_DURATION = 1000
SLEEP_ANIMATION_EASING = 'in'
SLEEP_LEGEND_POSITION = 'none'

SELF_CARE_PRIMARY_COLOR = "#8e44ad"
SELF_CARE_BACKGROUND_COLOR = "#fff"
SELF_CARE_STROKE_WIDTH = 0
SELF_CARE_ANIMATION_DURATION = 1000
SELF_CARE_ANIMATION_EASING = 'in'
SELF_CARE_LEGEND_POSITION = 'none'

JOURNAL_PRIMARY_COLOR = "#f39c12"
JOURNAL_BACKGROUND_COLOR = "#fff"
JOURNAL_STROKE_WIDTH = 0
JOURNAL_ANIMATION_DURATION = 1000
JOURNAL_ANIMATION_EASING = 'in'
JOURNAL_LEGEND_POSITION = 'none'

# Game Settings
RANK_CONSTANT = 1

MOOD_BASE_PERK_VALUE = 1
MOOD_MULTIPLIER_PERK_VALUE = 1
MOOD_STREAK_PERK_VALUE = 1

SLEEP_BASE_PERK_VALUE = 1
SLEEP_MULTIPLIER_PERK_VALUE = 1
SLEEP_STREAK_PERK_VALUE = 1

SELFCARE_BASE_PERK_VALUE = 1
SELFCARE_MULTIPLIER_PERK_VALUE = 1
SELFCARE_STREAK_PERK_VALUE = 1

JOURNAL_BASE_PERK_VALUE = 1
JOURNAL_MULTIPLIER_PERK_VALUE = 1
JOURNAL_STREAK_PERK_VALUE = 1