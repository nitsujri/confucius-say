class LearnController < ApplicationController
  layout "application_no_s"

  def tones
    @the_tones = [
      {
        chars_trad: "一",
        link:       "/一-one-1-single-a/37",
        jyutping:   "jat1",
        english:    "One",
      },
      {
        chars_trad: "碗",
        link:       "/碗-bowl-cup-cl/63429",
        jyutping:   "wun2",
        english:    "Bowl",
      },
      {
        chars_trad: "細",
        link:       "/細-thin-or-slender-finely-particulate-thin-and-soft-fine-delicate-trifling--quiet-frugal/67683",
        jyutping:   "sai3",
        english:    "Small",
      },
      {
        chars_trad: "牛",
        link:       "/牛-surname-niu/56934",
        jyutping:   "ngau4",
        english:    "Beef (cow)",
      },
      {
        chars_trad: "腩",
        link:       "/腩-brisket-belly-beef-spongy-meat-from-cows-underside-and-neighboring-ribs-see--esp-cantonese-erroneously-translated-as-sirloin/72136",
        jyutping:   "lam5",
        english:    "Brisket",
      },
      {
        chars_trad: "麵",
        link:       "/麵-flour-noodles/98006",
        jyutping:   "min6",
        english:    "Noodles",
      },
    ]

  end
end
