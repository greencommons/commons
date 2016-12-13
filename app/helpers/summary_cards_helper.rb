module SummaryCardsHelper
  def summary_card_for(resource)
    {
      Group => 'shared/summary_cards/group',
      GroupsUser => 'shared/summary_cards/member',
    }[resource.class]
  end
end
