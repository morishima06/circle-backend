# frozen_string_literal: true

# categories
CATEGORIES = {
  pants: Category.find_by!(slug: 'pants'),
  sweatshirts: Category.find_by!(slug: 'sweatshirts'),
  hoodies: Category.find_by!(slug: 'hoodies'),
  tshirts: Category.find_by!(slug: 't-shirts'),
  shirts: Category.find_by!(slug: 'shirts'),
  jackets: Category.find_by!(slug: 'jackets'),
  jeans: Category.find_by!(slug: 'jeans'),

  tote_bags: Category.find_by!(slug: 'tote-bags'),
  backpacks: Category.find_by!(slug: 'backpacks'),

  caps: Category.find_by!(slug: 'caps'),
  socks: Category.find_by!(slug: 'socks'),
  belts: Category.find_by!(slug: 'belts'),
  wallets: Category.find_by!(slug: 'wallets'),
  underwear: Category.find_by!(slug: 'underwear'),

  footwear: Category.find_by!(slug: 'footwear'),
  sneakers: Category.find_by!(slug: 'sneakers'),
  boots: Category.find_by!(slug: 'boots')
}.freeze

# designers
DESIGNERS = {
  d424: Designer.find_by!(slug: '424'),
  alyx: Designer.find_by!(slug: '1017-alyx-9sm'),
  apc: Designer.find_by!(slug: 'apc'),
  acne: Designer.find_by!(slug: 'acne-studios'),
  acw: Designer.find_by!(slug: 'a-cold-wall'),
  asics: Designer.find_by!(slug: 'asics'),
  ader_error: Designer.find_by!(slug: 'ader-error'),
  adidas: Designer.find_by!(slug: 'adidas'),
  and_wander: Designer.find_by!(slug: 'and-wander'),
  balenciaga: Designer.find_by!(slug: 'balenciaga'),
  cp_company: Designer.find_by!(slug: 'cp-company'),
  ce: Designer.find_by!(slug: 'ce'),
  diesel: Designer.find_by!(slug: 'diesel'),
  edwin: Designer.find_by!(slug: 'edwin'),
  fog: Designer.find_by!(slug: 'fear-of-god'),
  gramicci: Designer.find_by!(slug: 'gramicci'),
  human_made: Designer.find_by!(slug: 'human-made'),
  jw_anderson: Designer.find_by!(slug: 'jw-anderson'),
  kenzo: Designer.find_by!(slug: 'kenzo'),
  lacoste: Designer.find_by!(slug: 'lacoste'),
  new_era: Designer.find_by!(slug: 'new-era'),
  nanamica: Designer.find_by!(slug: 'nanamica'),
  nike: Designer.find_by!(slug: 'nike'),
  oamc: Designer.find_by!(slug: 'oamc'),
  porter: Designer.find_by!(slug: 'porter-yoshida'),
  polo: Designer.find_by!(slug: 'polo-ralph-lauren'),
  stone_island: Designer.find_by!(slug: 'stone-island'),
  palm_angels: Designer.find_by!(slug: 'palm-angels'),
  undercover: Designer.find_by!(slug: 'undercover'),
  vans: Designer.find_by!(slug: 'vans'),
  wood_wood: Designer.find_by!(slug: 'wood-wood'),
  y3: Designer.find_by!(slug: 'y-3')
}.freeze

# colors
COLORS = {
  white: Color.find_by!(slug: 'white'),
  black: Color.find_by!(slug: 'black'),
  gray: Color.find_by!(slug: 'gray'),
  navy: Color.find_by!(slug: 'navy'),
  blue: Color.find_by!(slug: 'blue'),
  brown: Color.find_by!(slug: 'brown'),
  green: Color.find_by!(slug: 'green'),
  red: Color.find_by!(slug: 'red')
}.freeze

SIZE = {
  s: Size.find_by!(label: 'S'),
  m: Size.find_by!(label: 'M'),
  l: Size.find_by!(label: 'L'),
  xl: Size.find_by!(label: 'XL'),
  size_26: Size.find_by!(label: '26.0'),
  size_26_5: Size.find_by!(label: '26.5'),
  size_27: Size.find_by!(label: '27.0'),
  size_27_5: Size.find_by!(label: '27.5'),
  size_28: Size.find_by!(label: '28.0'),
  size_28_5: Size.find_by!(label: '28.5'),
  one_size: Size.find_by!(label: 'ONE SIZE')
}.freeze

product_data = [
  {
    category: CATEGORIES[:tshirts],
    designer: DESIGNERS[:apc],
    gender: :men,
    status: 'published',
    style_code: 'COHBU-M26388-TZC',
    color: COLORS[:white],
    images: ['apc_cohbu_m26388_tzc_1.png'],
    name: 'Rue Madame Logo T-Shirt',
    price: 1000,
    sale_price: 200,
    description: "A.P.C.は、クリーンなラインと洗練されたベーシックアイテムを軸にブランドのアイデンティティを築いてきました。その姿勢はクルーネックのTシャツ一枚にさえも表れています。\n" \
                 "Standard Rue Madame Tシャツは、GOTS認証を受けたヘビーウェイトのオーガニックコットンを使用し、胸元にはさりげない刺繍をあしらったデザイン。\n" \
                 '肩の力を抜いた、控えめで静かなラグジュアリーを体現する一着です。ブランドが拠点とするパリの通り「Rue Madame」と、フラッグシップストアへのオマージュも込められています。',
    specs_attributes: [
      { key: '原産国', value: 'イタリア' },
      { key: '素材', value: '100%コットン' }
    ],
    sale_start_at: Time.current,
    sale_end_at: 14.days.from_now,
    release_at: Time.current,
    skus_attributes: [
      { size: SIZE[:s], stock: 10 },
      { size: SIZE[:m], stock: 10 },
      { size: SIZE[:l], stock: 0 }
    ]
  },

  {
    category: CATEGORIES[:belts],
    designer: DESIGNERS[:balenciaga],
    gender: :men,
    status: 'published',
    style_code: '835561-2ABZI-1000',
    color: COLORS[:black],
    images: ['balenciaga_835561_2abzi_1000_1.png'],
    name: 'BA beans belt',
    price: 3000,
    sale_price: 200,
    description: '鍵やIDホルダーとして使える実用的なアイテムで、日常の必需品にさりげないラグジュアリー感をプラスします。',
    specs_attributes: [
      { key: '原産国', value: 'イタリア' },
      { key: '素材', value: '100%コットン' }
    ],
    sale_start_at: Time.current,
    sale_end_at: 14.days.from_now,
    release_at: Time.current,
    skus_attributes: [
      { size: SIZE[:one_size], stock: 10 }
    ]
  },

  {
    category: CATEGORIES[:hoodies],
    designer: DESIGNERS[:cp_company],
    gender: :men,
    status: 'published',
    style_code: '19CMOW702A-110416A-815',
    color: COLORS[:green],
    images: [
      'cp_company_19cmow702a_110416a_815_1.png',
      'cp_company_19cmow702a_110416a_815_2.png',
      'cp_company_19cmow702a_110416a_815_3.png'
    ],
    name: 'DD-Shell Hooded Jacket',
    price: 3000,
    sale_price: 200,
    description: "ブランドの卓越したクラフツマンシップを体現するC.P. CompanyのD.Dジャケットは、7デニールのマイクロリップストップ・オペークナイロン素材を使用しています。\n" \
                 "軽量な生地がガーメントの構造美を際立たせ、Direct Downインジェクションによって優れた保温性を実現。\n" \
                 '必需品を収納できる拡張ジップポケットを備え、袖にはアイコニックなゴーグルパッチをあしらうことで、デザインを完成させています。',
    specs_attributes: [
      { key: '素材', value: 'ナイロン100%' },
      { key: '裏地', value: 'ポリアミド100%' },
      { key: '中綿', value: 'ポリエステル100%' }
    ],
    sale_start_at: Time.current,
    sale_end_at: Time.current,
    release_at: Time.current,
    skus_attributes: [
      { size: SIZE[:s], stock: 10 },
      { size: SIZE[:m], stock: 10 }
    ]
  },

  {
    category: CATEGORIES[:sweatshirts],
    designer: DESIGNERS[:cp_company],
    gender: :men,
    status: 'published',
    style_code: '20CMSS716A-005086W-921',
    color: COLORS[:black],
    images: [
      'cp_company_20cmss716a_005086w_921_1.png',
      'cp_company_20cmss716a_005086w_921_2.png'
    ],
    name: 'Diagonal Raised Fleece Hooded Lens Sweatshirt',
    price: 5000,
    sale_price: 200,
    description: 'イタリア発のブランド C.P. Company は、独自のテクニカル視点と素材革新によって' \
                 "日常の定番アイテムを再解釈しています。\n" \
                 '「Diagonal Raised フリース フーデッド Lens スウェットシャツ」は、やわらかなミッドウェイトの' \
                 "起毛ダイアゴナル織りコットンを使用し、快適で着やすいワードローブの定番として仕上げられています。\n" \
                 'クリーンでミニマルなデザインに、袖のアイコニックなLensディテールをあしらい、' \
                 'ブランドらしいシグネチャーのアクセントを加えています。',
    specs_attributes: [
      { key: '素材', value: 'コットン100%' }
    ],
    sale_start_at: Time.current,
    sale_end_at: Time.current,
    release_at: Time.current,
    skus_attributes: [
      { size: SIZE[:s], stock: 10 },
      { size: SIZE[:m], stock: 10 }
    ]
  },

  {
    category: CATEGORIES[:jeans],
    designer: DESIGNERS[:edwin],
    gender: :men,
    status: 'published',
    style_code: 'I035082-89OC',
    color: COLORS[:black],
    images: [
      'edwin_i035082_89oc_1.png',
      'edwin_i035082_89oc_2.png',
      'edwin_i035082_89oc_3.png'
    ],
    name: 'Regular Tapered Denim Jeans',
    price: 1000,
    sale_price: 200,
    description: "日本のデニム生産における基準を打ち立ててきたEdwinのジーンズは、耐久性に優れたコットン素材で仕立てられています。\n" \
                 '卓越したクラフツマンシップを体現し、脚にかけてレギュラーテーパードのシルエットで仕上げることで、クラシックなルックを演出しています。',
    specs_attributes: [
      { key: '素材', value: 'コットン100%' }
    ],
    sale_start_at: Time.current,
    sale_end_at: 14.days.from_now,
    release_at: Time.current,
    skus_attributes: [
      { size: SIZE[:s], stock: 10 },
      { size: SIZE[:m], stock: 10 },
      { size: SIZE[:l], stock: 0 }
    ]
  },

  {
    category: CATEGORIES[:caps],
    designer: DESIGNERS[:fog],
    gender: :men,
    status: 'published',
    style_code: 'FGE270089OXF',
    color: COLORS[:green],
    images: [
      'fog_fge270089oxf_1.png',
      'fog_fge270089oxf_2.png',
      'fog_fge270089oxf_3.png'
    ],
    name: 'Embroidered Logo Cap',
    price: 4000,
    sale_price: 200,
    description: 'ミニマルな美学と上質な素材使いで知られるFEAR OF GODのエッセンスを体現した、' \
                 "洗練されたロゴキャップ。\n" \
                 'フロントにはブランドを象徴するロゴ刺繍をあしらい、シンプルながらも存在感のあるデザインに仕上げています。' \
                 "落ち着いたカラーリングと無駄のないシルエットは、ストリートからモードまで幅広いスタイルに自然に馴染みます。\n" \
                 'バックにはサイズ調整可能なストラップを備え、快適なフィット感を実現。デイリーユースはもちろん、' \
                 'コーディネートのアクセントとしても活躍するアイテムです。',
    specs_attributes: [
      { key: '素材', value: 'コットン52%、ヴァージンウール46%、エラスタン2%' },
      { key: '原産国', value: 'イタリア製' }
    ],
    sale_start_at: Time.current,
    sale_end_at: Time.current,
    release_at: Time.current,
    skus_attributes: [
      { size: SIZE[:one_size], stock: 10 }
    ]
  },

  {
    category: CATEGORIES[:socks],
    designer: DESIGNERS[:gramicci],
    gender: :men,
    status: 'published',
    style_code: 'SX-M06-WHT',
    color: COLORS[:white],
    images: ['gramicci_sx_m06_wht_1.png'],
    name: 'Basic Crew Socks',
    price: 1000,
    sale_price: 200,
    description: "日常使いに最適で、Gramicciらしいシグネチャースタイル。快適な履き心地を追求して作られています。\n" \
                 '足首よりやや上にくる丈感に仕上げられ、それぞれのペアにはブランドを象徴する"Running Man"ロゴを刺繍で配置。トーン違いの3色で表現され、洗練された仕上がりになっています。',
    specs_attributes: [
      { key: '素材', value: 'コットン100%' }
    ],
    sale_start_at: Time.current,
    sale_end_at: 14.days.from_now,
    release_at: Time.current,
    skus_attributes: [
      { size: SIZE[:s], stock: 10 },
      { size: SIZE[:m], stock: 10 }
    ]
  },

  {
    category: CATEGORIES[:backpacks],
    designer: DESIGNERS[:porter],
    gender: :men,
    status: 'published',
    style_code: '622-01630-50',
    color: COLORS[:navy],
    images: [
      'porter_622_01630_1.png',
      'porter_622_01630_2.png',
      'porter_622_01630_3.png'
    ],
    name: 'Tanker Backpack',
    price: 1300,
    sale_price: 200,
    description: '1935年に東京で創業したPorter-Yoshida & Co.は、妥協のないクラフツマンシップと' \
                 "時代を超えて愛される実用性で高く評価されています。\n" \
                 'ブランドを象徴するシリーズのひとつで、MA-1フライトジャケットに着想を得た「Tanker」バックパックは、' \
                 "軽量な3層構造ファブリックと鮮やかなレスキューオレンジのライニングが特徴です。\n" \
                 '拡張可能なフロントポケットやサイドアクセスジッパー、ヴィンテージ感のあるメタルパーツを備え、' \
                 '日常使いに適した機能性とヘリテージの魅力を兼ね備えています。',
    specs_attributes: [
      { key: '素材', value: 'ナイロン100%' },
      { key: 'ポケット', value: '外側・内側ポケット付き' }
    ],
    sale_start_at: Time.current,
    sale_end_at: Time.current,
    release_at: Time.current,
    skus_attributes: [
      { size: SIZE[:one_size], stock: 10 }
    ]
  },

  {
    category: CATEGORIES[:jackets],
    designer: DESIGNERS[:acne],
    gender: :men,
    status: 'published',
    style_code: 'C90210-969',
    color: COLORS[:black],
    images: [
      'acne_c90210_969_1.png',
      'acne_c90210_969_2.png',
      'acne_c90210_969_3.png'
    ],
    name: 'Gothik Wash Hooded Denim Jacket',
    price: 1000,
    sale_price: 200,
    description: "ミッドトーンのエコウォッシュで仕上げられたAcne StudiosのGothikデニムジャケットは、ひとつひとつが個性的な仕上がり。\n" \
                 'Jonny Johanssonが掲げる"マキシマル・ミニマリズム"の哲学を体現し、ベーシックでありながら、さりげないエッジを効かせた一着です。',
    specs_attributes: [
      { key: '素材', value: 'コットン82%、リヨセル18%' },
      { key: 'シルエット', value: 'リラックスフィット' }
    ],
    sale_start_at: Time.current,
    sale_end_at: 14.days.from_now,
    release_at: Time.current,
    skus_attributes: [
      { size: SIZE[:s], stock: 10 },
      { size: SIZE[:m], stock: 10 }
    ]
  },

  {
    category: CATEGORIES[:jeans],
    designer: DESIGNERS[:apc],
    gender: :men,
    status: 'published',
    style_code: 'COZZI-H09121-IAI',
    color: COLORS[:navy],
    images: [
      'apc_cozzi_h09121_iai_1.png',
      'apc_cozzi_h09121_iai_2.png',
      'apc_cozzi_h09121_iai_3.png'
    ],
    name: 'Martin Jeans',
    price: 1040,
    sale_price: 200,
    description: "90年代スタイルが再び注目を集めるなか、A.P.C.のMartinジーンズは、気取らないクールさを感じさせるストレートレッグのストーンウォッシュデザインを体現しています。\n" \
                 "ワイドレッグのシルエットは、足首にかけてさりげなくテーパードしており、リラックス感と洗練さの絶妙なバランスを実現。\n" \
                 'さらに、キャラメルカラーのトップステッチやシルバートーンのリベットといった細部へのこだわりが、デザイン全体に上品な仕上がりを添えています。',
    specs_attributes: [
      { key: '素材', value: 'オーガニックコットン100%' },
      { key: 'シルエット', value: 'ワイドレッグフィット' },
      { key: '仕様', value: 'ボタン＆ジップ' }
    ],
    sale_start_at: Time.current,
    sale_end_at: Time.current,
    release_at: Time.current,
    skus_attributes: [
      { size: SIZE[:s], stock: 10 },
      { size: SIZE[:m], stock: 10 }
    ]
  },

  {
    category: CATEGORIES[:caps],
    designer: DESIGNERS[:apc],
    gender: :men,
    status: 'published',
    style_code: 'COHKM-M24173-CAB',
    color: COLORS[:gray],
    images: [
      'apc_cohkm_m24173_cab_1.png',
      'apc_cohkm_m24173_cab_2.png',
      'apc_cohkm_m24173_cab_3.png'
    ],
    name: 'Charlie Cap',
    price: 7000,
    sale_price: 200,
    description: "A.P.C.のCharlieキャップで、コーディネートにクリーンでミニマルなエッジをプラス。\n" \
                 '上質なファブリックを使用し、立体感のある構造的なフィットに仕上げられています。通気性を高めるアイレットを備え、一日中快適な被り心地を実現。スタイルと機能性を絶妙に両立したアイテムです。',
    specs_attributes: [
      { key: '素材', value: 'コットン98%、ポリウレタン2%' }
    ],
    sale_start_at: Time.current,
    sale_end_at: 14.days.from_now,
    release_at: Time.current,
    skus_attributes: [
      { size: SIZE[:one_size], stock: 10 }
    ]
  },

  {
    category: CATEGORIES[:tshirts],
    designer: DESIGNERS[:cp_company],
    gender: :men,
    status: 'published',
    style_code: '19CMTS091A-005100W-103',
    color: COLORS[:white],
    name: 'Logo T-Shirt',
    price: 4000,
    sale_price: 200,
    description: 'C.P. Companyは、ブランドの海洋テイストに着想を得たヘリテージを反映し、' \
                 "「30/1 British Sailor Tシャツ」でクリーンなデイリーウェアにさりげない個性を加えています。\n" \
                 "軽量で柔らかなコットンジャージー素材を使用し、通気性に優れた快適な着心地とクラシックなフィットを実現。\n" \
                 '背面と胸元には、ブランドの航海的ルーツを象徴するBritish Sailorグラフィックを大胆に配置し、' \
                 'ミニマルなシルエットにアクセントを添えています。',
    specs_attributes: [
      { key: '素材', value: 'コットン100%' },
      { key: '襟元', value: 'クルーネック' }
    ],
    sale_start_at: Time.current,
    sale_end_at: Time.current,
    release_at: Time.current,
    skus_attributes: [
      { size: SIZE[:s], stock: 10 },
      { size: SIZE[:m], stock: 10 }
    ]
  },

  {
    category: CATEGORIES[:tshirts],
    designer: DESIGNERS[:apc],
    gender: :men,
    status: 'published',
    style_code: 'COHBM-M26384-TPI',
    color: COLORS[:white],
    name: 'VPC Logo T-Shirt',
    price: 4000,
    sale_price: 200,
    description: "肩の力を抜いたスタイルで、ひと目でそれとわかるA.P.C.らしさを体現するロゴTシャツ。\n" \
                 '超ソフトなコットン素材から仕立てられ、リラックス感のあるゆったりとしたフィットに仕上げられています。' \
                 "フロントには大胆なVPCロゴをあしらい、ブランドのパリにルーツを持つ背景をさりげなく表現。\n" \
                 'クリーンでシンプルだからこそ、何度でも手に取りたくなる一枚です。',
    specs_attributes: [
      { key: '素材', value: 'コットン100%' },
      { key: '襟元', value: 'クルーネック' }
    ],
    sale_start_at: Time.current,
    sale_end_at: 14.days.from_now,
    release_at: Time.current,
    skus_attributes: [
      { size: SIZE[:s], stock: 10 },
      { size: SIZE[:m], stock: 10 }
    ]
  },

  {
    category: CATEGORIES[:jeans],
    designer: DESIGNERS[:apc],
    gender: :men,
    status: 'published',
    style_code: 'COHAD-H09010-IAL',
    color: COLORS[:blue],
    name: 'Rescue Jeans',
    price: 4000,
    sale_price: 200,
    description: "A.P.C.のRescueジーンズは、日常のデニムに対するブランドの洗練されたアプローチを体現しています。\n" \
                 'ストレートレッグとミッドライズのシルエットで仕立てられ、タイムレスな構築美と快適な履き心地を絶妙に両立。' \
                 '特徴的なストーンウォッシュ加工がこなれた風合いを演出し、シグネチャーの"ギター＆ダガー"ボタンや' \
                 "シルバートーンのリベットがさりげないエッジを添えます。\n" \
                 'クラシックな5ポケット仕様で仕上げられた一本は、控えめなデザインと確かなクラフツマンシップを融合させた、' \
                 '現代のワードローブに欠かせないアイテムです.',
    specs_attributes: [
      { key: '素材', value: 'コットン100%' },
      { key: 'シルエット', value: 'ストレートレッグ' },
      { key: '股上', value: 'ミッドライズ' },
      { key: 'ポケット', value: '5ポケット' }
    ],
    sale_start_at: Time.current,
    sale_end_at: 14.days.from_now,
    release_at: Time.current,
    skus_attributes: [
      { size: SIZE[:s], stock: 10 },
      { size: SIZE[:m], stock: 10 }
    ]
  },

  {
    category: CATEGORIES[:sneakers],
    designer: DESIGNERS[:nike],
    gender: :men,
    status: 'published',
    style_code: 'IH1413-001',
    color: COLORS[:black],
    name: 'Air Max 95 Big Bubble Sneaker',
    price: 4000,
    sale_price: 200,
    description: '',
    specs_attributes: [
      { key: '素材', value: 'レザー' }
    ],
    sale_start_at: Time.current,
    sale_end_at: 14.days.from_now,
    release_at: Time.current,
    skus_attributes: [
      { size: SIZE[:size_26], stock: 10 },
      { size: SIZE[:size_26_5], stock: 10 },
      { size: SIZE[:size_27], stock: 10 },
      { size: SIZE[:size_27_5], stock: 10 },
      { size: SIZE[:size_28], stock: 10 },
      { size: SIZE[:size_28_5], stock: 10 }
    ]
  },

  {
    category: CATEGORIES[:jackets],
    designer: DESIGNERS[:nanamica],
    gender: :men,
    status: 'published',
    style_code: 'S25FA012E-DN',
    color: COLORS[:blue],
    name: 'Hooded Deck Jacket',
    price: 4000,
    sale_price: 200,
    description: "流行に左右されないデザインの、ミリタリー（ネイビー）テイストを取り入れた Nanamica のジャケット。日常使いに最適な一着です。\n" \
                 'アウトドア機能性とクリーンなデザインを融合し、コットン混紡素材を使用した防水シェルとゆったりとしたシルエットが特徴。' \
                 'スタンドカラーとドローコード付きフードを備え、裾には収納力に優れた大きなフラップポケットを配置しています。',
    specs_attributes: [
      { key: '素材', value: 'ポリエステル 65%、コットン 35%' }
    ],
    sale_start_at: Time.current,
    sale_end_at: 14.days.from_now,
    release_at: Time.current,
    skus_attributes: [
      { size: SIZE[:s], stock: 10 },
      { size: SIZE[:m], stock: 10 },
      { size: SIZE[:l], stock: 10 }
    ]
  },

  {
    category: CATEGORIES[:jackets],
    designer: DESIGNERS[:palm_angels],
    gender: :men,
    status: 'published',
    style_code: 'PMHA061S25KNI0011003',
    color: COLORS[:black],
    name: 'Palm Knit Track Top',
    price: 40_000,
    sale_price: 20_000,
    description: "クラシックなツイードを現代的に再解釈した一本。REWOOL ワイドトラウザーズは、リサイクルポリエステルと未使用の糸を使用して作られ、リラックス感のあるシルエットに仕立てられています。\n" \
                 '伝統的なテーラリングの要素を取り入れながら、現代的な快適さを兼ね備えたデザインが特徴です。\n' \
                 '暖かく通気性にも優れ、控えめながらも存在感のある仕上がりで、アウトドアからタウンユースまで幅広いシーンで活躍します。',
    specs_attributes: [
      { key: '素材', value: 'コットン 60%、メリノウール 40%' },
      { key: '仕様', value: 'リラックスフィット' }
    ],
    sale_start_at: Time.current,
    sale_end_at: 14.days.from_now,
    release_at: Time.current,
    skus_attributes: [
      { size: SIZE[:s], stock: 10 },
      { size: SIZE[:m], stock: 0 },
      { size: SIZE[:l], stock: 10 }
    ]
  },

  {
    category: CATEGORIES[:jackets],
    designer: DESIGNERS[:y3],
    gender: :men,
    status: 'published',
    style_code: 'KF1085',
    color: COLORS[:blue],
    name: 'Wired Hooded Jacket',
    price: 38_000,
    sale_price: 22_000,
    description: '洗練されたシャープなデザインが特徴の Y-3 ワイヤード フーデッドジャケットは、' \
                 "クラシックなスポーツウェアにモダンで洗練されたエッジを加えた一着。\n" \
                 '軽量なウーブン素材を使用し、ゆとりのあるシルエットが自然なドレープを生み出し、' \
                 'レイヤードスタイルにも最適です。ワイヤー入りフードとアイコニックなスリーストライプスが' \
                 "立体感とデザイン性をプラスし、ミニマルな仕上がりが上品な印象を演出します。\n" \
                 'ハイファッションの感性と adidas のパフォーマンスヘリテージを融合させた、' \
                 '存在感のあるアウターです。',
    specs_attributes: [
      { key: '素材', value: 'ナイロン100%' }
    ],
    sale_start_at: Time.current,
    sale_end_at: 14.days.from_now,
    release_at: Time.current,
    skus_attributes: [
      { size: SIZE[:s], stock: 10 },
      { size: SIZE[:m], stock: 10 }
    ]
  },

  {
    category: CATEGORIES[:pants],
    designer: DESIGNERS[:and_wander],
    gender: :men,
    status: 'published',
    style_code: '5745282099-010',
    color: COLORS[:black],
    name: 'REWOOL Tweed Wide Trousers',
    price: 23_000,
    sale_price: 12_000,
    description: "クラシックなツイードを現代的に再解釈した一本。REWOOL ワイドトラウザーズは、リサイクルポリエステルと未使用の糸を使用して作られ、リラックス感のあるシルエットに仕立てられています。\n" \
                 '伝統的なテーラリングの要素を取り入れながら、現代的な快適さを兼ね備えたデザインが特徴です。\n' \
                 '暖かく通気性にも優れ、控えめながらも存在感のある仕上がりで、アウトドアからタウンユースまで幅広いシーンで活躍します。',

    specs_attributes: [
      { key: '素材', value: 'ナイロン100%' },
      { key: 'シルエット', value: 'ワイドレッグ' }
    ],
    sale_start_at: Time.current,
    sale_end_at: 14.days.from_now,
    release_at: Time.current,
    skus_attributes: [
      { size: SIZE[:s], stock: 0 },
      { size: SIZE[:m], stock: 10 }
    ]
  },

  {
    category: CATEGORIES[:tshirts],
    designer: DESIGNERS[:jw_anderson],
    gender: :men,
    status: 'published',
    style_code: 'JT0257-PG1510-001',
    color: COLORS[:white],
    name: 'Jersey Anchor Embroidery T-Shirt',
    price: 9000,
    sale_price: 5500,
    description: "ラグジュアリーメンズウェアの定番として知られる JW Anderson のTシャツ。\n" \
                 '柔らかなコットンジャージー素材を使用し、快適な着心地と洗練されたスタイルを兼ね備えた一枚です。' \
                 '胸元にはブランドを象徴するアンカーモチーフを配置し、マリンテイストを感じさせるアクセントをプラスしています。',
    specs_attributes: [
      { key: '素材', value: 'コットン100%' },
      { key: 'ディテール', value: 'クルーネック' }
    ],
    sale_start_at: Time.current,
    sale_end_at: 14.days.from_now,
    release_at: Time.current,
    skus_attributes: [
      { size: SIZE[:s], stock: 10 },
      { size: SIZE[:m], stock: 10 }
    ]
  },

  {
    category: CATEGORIES[:shirts],
    designer: DESIGNERS[:wood_wood],
    gender: :men,
    status: 'published',
    style_code: '30251942',
    color: COLORS[:green],
    name: 'Clay Shirt',
    price: 38_000,
    sale_price: 22_000,
    description: "ストレートシルエットが特徴のシャツジャケット。構築的なカラーとロングスリーブに加え、胸元には存在感のあるオーバーサイズのパッチポケットを2つ配置しています。\n" \
                 'マットで滑らかな質感のボタンフロントが、クリーンでユーティリティ感のある印象を演出。さりげないクールさが際立つ一着です。',
    specs_attributes: [
      { key: '素材', value: 'コットン100%' }
    ],
    sale_start_at: Time.current,
    sale_end_at: 14.days.from_now,
    release_at: Time.current,
    skus_attributes: [
      { size: SIZE[:s], stock: 10 },
      { size: SIZE[:m], stock: 10 },
      { size: SIZE[:l], stock: 10 },
      { size: SIZE[:xl], stock: 10 }
    ]
  },

  {
    category: CATEGORIES[:sneakers],
    designer: DESIGNERS[:asics],
    gender: :men,
    status: 'published',
    style_code: '1203A388.002',
    color: COLORS[:green],
    name: 'GEL-KAYANO 20',
    price: 25_000,
    description: "ASICSの名作「GEL-KAYANO™」シリーズへのオマージュとして誕生したGEL-KAYANO 14スニーカー。\n" \
                 "2000年代後半のランニングシューズの美学を現代に蘇らせ、クラシックなデザインと最新テクノロジーを融合した一足です。\n" \
                 "本モデルは、シリーズ創設者であるToshikazu Kayanoがデザインを手がけなかった初のGEL-KAYANOとしても知られ、ブランドの新たな時代の幕開けを象徴しています。\n" \
                 'ヴィンテージ感のあるルックスでヘリテージを継承しながら、最先端素材を採用することでパフォーマンス性を向上。過去と未来が交差する、ASICSの革新性を体現したモデルです。',
    specs_attributes: [
      { key: '素材', value: 'コットン100%' }
    ],
    sale_start_at: Time.current,
    sale_end_at: 14.days.from_now,
    release_at: Time.current,
    skus_attributes: [
      { size: SIZE[:size_26], stock: 0 },
      { size: SIZE[:size_26_5], stock: 10 },
      { size: SIZE[:size_27], stock: 10 },
      { size: SIZE[:size_27_5], stock: 0 },
      { size: SIZE[:size_28], stock: 10 },
      { size: SIZE[:size_28_5], stock: 10 }
    ]
  }
]


# ===============================
# 3. 画像紐付けメソッド定義
# ===============================

def attach_product_image(product_image, filename)
  if Rails.env.production?
    # S3上のオブジェクトキー
    key = "products/#{filename}"

    service_name = Rails.application.config.active_storage.service.to_s

    # 既存のBlobを検索
    blob = ActiveStorage::Blob.find_by(
      key: key,
      service_name: service_name
    )

    unless blob
      # S3から画像を取得
      file_data = ActiveStorage::Blob.service.download(key)

      # 既存S3画像に対応するBlobレコードを作成
      blob = ActiveStorage::Blob.create!(
        key: key,
        filename: filename,
        content_type: Marcel::MimeType.for(filename),
        metadata: {},
        byte_size: file_data.bytesize,
        checksum: Digest::MD5.base64digest(file_data),
        service_name: service_name
      )
    end

    # 商品画像にBlobを紐付け
    product_image.image.attach(blob)

  else
    # developmentではローカル画像を使用
    path = Rails.root.join(
      "db/seeds/development/images/#{filename}"
    )

    product_image.image.attach(
      io: File.open(path),
      filename: filename
    )
  end
end


# ===============================
# 4. 商品データをループ
# ===============================

product_data.each do |data|

  # 画像ファイル名を取得
  image_filenames = data[:images] || []

  # ===============================
  # 5. 商品を作成
  # ===============================

  product = Product.create!(
    data.except(:images)
  )

  # ===============================
  # 6. 画像レコードを作成して紐付け
  # ===============================

  image_filenames.each_with_index do |filename, index|

    # ProductImageレコードを作成
    product_image = product.product_images.create!(
      position: index + 1
    )

    # 画像を紐付け
    attach_product_image(product_image, filename)

  end
end