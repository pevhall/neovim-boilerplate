return {
	s("trig", t("loaded!!")),
  s("date", { extras.partial(os.date, "%Y-%m-%d") }),
  s("time", { extras.partial(os.date, "%H:%M:%S") }),
}
