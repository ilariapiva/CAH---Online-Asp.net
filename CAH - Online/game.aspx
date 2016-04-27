<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">
    
    int indexRoom;
    Room room;
    Cards blackCard;
    List<Cards> whiteCards = new List<Cards>();
    bool stateChanged = false;
    int totalSeconds = 0;
    int seconds = 0;
    int minutes = 0;
    string time = "";
    
    protected void Page_Load(object sender, EventArgs e)
    {
        FunctionsDB.OpenConnectionDB();

        //recupero l'id della room
        indexRoom = FunctionsDB.GetRoom(Master.resultUser);
            
        //assegno l'idRoom
        room = Game.UserEntered(indexRoom);
        
        int points = FunctionsDB.ReadPoints(indexRoom, Master.resultUser);
        
        lblPoints.Text = "Punteggio: " + points;

        lblUser1.Visible = false;
        lblUser2.Visible = false;
        lblUser3.Visible = false;
        lblUser4.Visible = false;
        lblUser5.Visible = false;
        lblUser6.Visible = false;
        lblUser7.Visible = false;
        lblUser8.Visible = false;
        lblUser9.Visible = false;
        lblUser10.Visible = false;
        lblUser11.Visible = false;
        lblUser12.Visible = false;

        btnWhite11.Visible = false;
        btnWhite12.Visible = false;

        if (!Page.IsPostBack)
        {
            stateChanged = true;
            Session["time0"] = 50; 
            Session["time1"] = 40; //definisco tempo per il conteggio alla rovescia. Il tempo stabilito è di 1 min e 40 sec
            Session["time2"] = 40;
            Session["time3"] = 3;       
            /* 100 = 1 min e 40 sec
             * 90 = 1 min 30 sec
             * 50 = 50 sec
             */
        }
        
        //room.GenerateCardsForUser(Master.resultUser);

        if (stateChanged)
        {
            //se l'utente è il master visualizzo solo la carta master 
            if (room.IsMaster(Master.resultUser))
            { 
                lblTimer.Visible = false;

                btnConfirmWinner.Visible = false;
                btnConfirmCardSelect.Visible = false;

                blackCard = room.GetCardBlack();
                lblBlack.Attributes.Add("value", blackCard.idCards.ToString());
                lblBlack.Text = blackCard.Text;

                int spacesBlackCard = room.CheckStringBlackCard();

                if (spacesBlackCard == 1)
                {
                    btnWhite1.Enabled = false;
                    btnWhite2.Enabled = false;
                    btnWhite3.Enabled = false;
                    btnWhite4.Enabled = false;
                    
                    btnWhite5.Visible = false;
                    btnWhite6.Visible = false;
                    btnWhite7.Visible = false;
                    btnWhite8.Visible = false;
                    btnWhite9.Visible = false;
                    btnWhite10.Visible = false;
                }

                if (spacesBlackCard == 2)
                {
                    btnWhite1.Enabled = false;
                    btnWhite2.Enabled = false;
                    btnWhite3.Enabled = false;
                    btnWhite4.Enabled = false;
                    btnWhite5.Enabled = false;
                    btnWhite6.Enabled = false;
                    btnWhite7.Enabled = false;
                    btnWhite8.Enabled = false;
                    
                    btnWhite9.Visible = false;
                    btnWhite10.Visible = false;
                }

                if (spacesBlackCard == 3)
                {
                    btnWhite11.Visible = true;
                    btnWhite12.Visible = true;
                    
                    btnWhite1.Enabled = false;
                    btnWhite2.Enabled = false;
                    btnWhite3.Enabled = false;
                    btnWhite4.Enabled = false;
                    btnWhite5.Enabled = false;
                    btnWhite6.Enabled = false;
                    btnWhite7.Enabled = false;
                    btnWhite8.Enabled = false;
                    btnWhite9.Enabled = false;
                    btnWhite10.Enabled = false;
                    btnWhite11.Enabled = false;
                    btnWhite12.Enabled = false;               
                }
            }

             //se l'utente nella stanza non è il master allora visualizzo la carta nera e le carte bianche
            if (!room.IsMaster(Master.resultUser))
            {
                lblTimerMaster.Visible = false;

                btnConfirmWinner.Visible = false;

                blackCard = room.GetCardBlack();
                lblBlack.Attributes.Add("value", blackCard.idCards.ToString());
                lblBlack.Text = blackCard.Text;

                whiteCards = room.GetCardsWhite(Master.resultUser);
               
                btnWhite1.Attributes.Add("value", whiteCards[0].idCards.ToString());
                btnWhite1.Text = whiteCards[0].Text;

                btnWhite2.Attributes.Add("value", whiteCards[1].idCards.ToString());
                btnWhite2.Text = whiteCards[1].Text;

                btnWhite3.Attributes.Add("value", whiteCards[2].idCards.ToString());
                btnWhite3.Text = whiteCards[2].Text;

                btnWhite4.Attributes.Add("value", whiteCards[3].idCards.ToString());
                btnWhite4.Text = whiteCards[3].Text;

                btnWhite5.Attributes.Add("value", whiteCards[4].idCards.ToString());
                btnWhite5.Text = whiteCards[4].Text;

                btnWhite6.Attributes.Add("value", whiteCards[5].idCards.ToString());
                btnWhite6.Text = whiteCards[5].Text;

                btnWhite7.Attributes.Add("value", whiteCards[6].idCards.ToString());
                btnWhite7.Text = whiteCards[6].Text;

                btnWhite8.Attributes.Add("value", whiteCards[7].idCards.ToString());
                btnWhite8.Text = whiteCards[7].Text;

                btnWhite9.Attributes.Add("value", whiteCards[8].idCards.ToString());
                btnWhite9.Text = whiteCards[8].Text;

                btnWhite10.Attributes.Add("value", whiteCards[9].idCards.ToString());
                btnWhite10.Text = whiteCards[9].Text;
            }
             
            stateChanged = false;
        }  
    }
    
    protected int RandomCard(List<Cards> listCards)
    {
        Random random = new Random();
        int r = random.Next(listCards.Count);
        return r;
    }

    protected void Timer1_Tick(object sender, EventArgs e)
    {
        if (room.IsMaster(Master.resultUser))
        {
            lblTimerMaster.Visible = true;
            btnConfirmWinner.Visible = true;
           
            Session["time0"] = Convert.ToInt16(Session["time0"]) - 1;
            if (Convert.ToInt16(Session["time0"]) <= 0)
            {
                lblTimer.Text = "TimeOut!";
                
                if (room.CheckUserCardSelected(indexRoom))
                {
                    List<Cards> textCardSelect = FunctionsDB.ReadTetxtCardsSelect(indexRoom);

                    int spacesBlackCard = room.CheckStringBlackCard();

                    if (room.UsersNotMaster(indexRoom) == 4)
                    {
                        if (spacesBlackCard == 1)
                        {
                            lblUser1.Visible = true;
                            lblUser1.Text = "User 1";

                            lblUser2.Visible = true;
                            lblUser2.Text = "User 2";

                            lblUser3.Visible = true;
                            lblUser3.Text = "User 3";

                            lblUser4.Visible = true;
                            lblUser4.Text = "User 4";

                            btnWhite1.Attributes.Add("value", textCardSelect[0].idCards.ToString());
                            btnWhite1.Text = textCardSelect[0].Text;

                            btnWhite2.Attributes.Add("value", textCardSelect[1].idCards.ToString());
                            btnWhite2.Text = textCardSelect[1].Text;

                            btnWhite3.Attributes.Add("value", textCardSelect[2].idCards.ToString());
                            btnWhite3.Text = textCardSelect[2].Text;

                            btnWhite4.Attributes.Add("value", textCardSelect[3].idCards.ToString());
                            btnWhite4.Text = textCardSelect[3].Text;

                            btnWhite1.Enabled = true;
                            btnWhite2.Enabled = true;
                            btnWhite3.Enabled = true;
                            btnWhite4.Enabled = true;
                        }

                        if (spacesBlackCard == 2)
                        {
                            lblUser1.Visible = true;
                            lblUser1.Text = "User 1";

                            lblUser2.Visible = true;
                            lblUser2.Text = "User 1";

                            lblUser3.Visible = true;
                            lblUser3.Text = "User 2";

                            lblUser4.Visible = true;
                            lblUser4.Text = "User 2";

                            lblUser5.Visible = true;
                            lblUser5.Text = "User 3";

                            lblUser6.Visible = true;
                            lblUser6.Text = "User 3";

                            lblUser7.Visible = true;
                            lblUser7.Text = "User 4";

                            lblUser8.Visible = true;
                            lblUser8.Text = "User 4";

                            btnWhite1.Attributes.Add("value", textCardSelect[0].idCards.ToString());
                            btnWhite1.Text = textCardSelect[0].Text;

                            btnWhite2.Attributes.Add("value", textCardSelect[1].idCards.ToString());
                            btnWhite2.Text = textCardSelect[1].Text;

                            btnWhite3.Attributes.Add("value", textCardSelect[2].idCards.ToString());
                            btnWhite3.Text = textCardSelect[2].Text;

                            btnWhite4.Attributes.Add("value", textCardSelect[3].idCards.ToString());
                            btnWhite4.Text = textCardSelect[3].Text;

                            btnWhite5.Attributes.Add("value", textCardSelect[4].idCards.ToString());
                            btnWhite5.Text = textCardSelect[4].Text;

                            btnWhite6.Attributes.Add("value", textCardSelect[5].idCards.ToString());
                            btnWhite6.Text = textCardSelect[5].Text;

                            btnWhite7.Attributes.Add("value", textCardSelect[6].idCards.ToString());
                            btnWhite7.Text = textCardSelect[6].Text;

                            btnWhite8.Attributes.Add("value", textCardSelect[7].idCards.ToString());
                            btnWhite8.Text = textCardSelect[7].Text;

                            btnWhite1.Enabled = true;
                            btnWhite3.Enabled = true;
                            btnWhite5.Enabled = true;
                            btnWhite7.Enabled = true;
                        }

                        if (spacesBlackCard == 3)
                        {
                            lblUser1.Visible = true;
                            lblUser1.Text = "User 1";

                            lblUser2.Visible = true;
                            lblUser2.Text = "User 1";

                            lblUser3.Visible = true;
                            lblUser3.Text = "User 1";

                            lblUser4.Visible = true;
                            lblUser4.Text = "User 2";

                            lblUser5.Visible = true;
                            lblUser5.Text = "User 2";

                            lblUser6.Visible = true;
                            lblUser6.Text = "User 2";

                            lblUser7.Visible = true;
                            lblUser7.Text = "User 3";

                            lblUser8.Visible = true;
                            lblUser8.Text = "User 3";

                            lblUser9.Visible = true;
                            lblUser9.Text = "User 3";

                            lblUser10.Visible = true;
                            lblUser10.Text = "User 4";

                            lblUser11.Visible = true;
                            lblUser11.Text = "User 4";

                            lblUser12.Visible = true;
                            lblUser12.Text = "User 4";

                            btnWhite1.Attributes.Add("value", textCardSelect[0].idCards.ToString());
                            btnWhite1.Text = textCardSelect[0].Text;

                            btnWhite2.Attributes.Add("value", textCardSelect[1].idCards.ToString());
                            btnWhite2.Text = textCardSelect[1].Text;

                            btnWhite3.Attributes.Add("value", textCardSelect[2].idCards.ToString());
                            btnWhite3.Text = textCardSelect[2].Text;

                            btnWhite4.Attributes.Add("value", textCardSelect[3].idCards.ToString());
                            btnWhite4.Text = textCardSelect[3].Text;

                            btnWhite5.Attributes.Add("value", textCardSelect[4].idCards.ToString());
                            btnWhite5.Text = textCardSelect[4].Text;

                            btnWhite6.Attributes.Add("value", textCardSelect[5].idCards.ToString());
                            btnWhite6.Text = textCardSelect[5].Text;

                            btnWhite7.Attributes.Add("value", textCardSelect[6].idCards.ToString());
                            btnWhite7.Text = textCardSelect[6].Text;

                            btnWhite8.Attributes.Add("value", textCardSelect[7].idCards.ToString());
                            btnWhite8.Text = textCardSelect[7].Text;

                            btnWhite9.Attributes.Add("value", textCardSelect[8].idCards.ToString());
                            btnWhite9.Text = textCardSelect[8].Text;

                            btnWhite10.Attributes.Add("value", textCardSelect[9].idCards.ToString());
                            btnWhite10.Text = textCardSelect[9].Text;

                            btnWhite11.Attributes.Add("value", textCardSelect[10].idCards.ToString());
                            btnWhite11.Text = textCardSelect[10].Text;

                            btnWhite12.Attributes.Add("value", textCardSelect[11].idCards.ToString());
                            btnWhite12.Text = textCardSelect[11].Text;

                            btnWhite1.Enabled = true;
                            btnWhite4.Enabled = true;
                            btnWhite7.Enabled = true;
                            btnWhite10.Enabled = true;
                        }
                    }
                   
                    Session["time2"] = Convert.ToInt16(Session["time2"]) - 1;
                    if (Convert.ToInt16(Session["time2"]) <= 0)
                    {
                        lblTimerMaster.Text = "TimeOut!";

                        if (btnConfirmWinner.Enabled == true)
                        {
                            int BlackCardSpaces = room.CheckStringBlackCard();

                            List<Cards> listCards = FunctionsDB.ReadTetxtCardsSelect(indexRoom);

                            if (BlackCardSpaces == 1)
                            {
                                int cardCount = RandomCard(listCards);
                                Cards cardSelect = new Cards();
                                cardSelect = listCards[cardCount];
                                NameUsers(BlackCardSpaces);
                                FunctionsDB.WritePointUserWin(indexRoom, cardSelect);
                                FunctionsDB.DeleteCardSelectDB(indexRoom);
                                btnConfirmWinner.Enabled = false;
                                room.NewRaund(indexRoom);
                                Timer1.Enabled = false;
                            }

                            if (BlackCardSpaces == 2)
                            {
                                int cardCount = RandomCard(listCards);
                                Cards cardSelect = new Cards();
                                cardSelect = listCards[cardCount];
                                NameUsers(BlackCardSpaces);
                                FunctionsDB.WritePointUserWin(indexRoom, cardSelect);
                                FunctionsDB.DeleteCardSelectDB(indexRoom);
                                btnConfirmWinner.Enabled = false;
                                room.NewRaund(indexRoom);
                                Timer1.Enabled = false;
                            }

                            if (BlackCardSpaces == 3)
                            {
                                int cardCount = RandomCard(listCards);
                                Cards cardSelect = new Cards();
                                cardSelect = listCards[cardCount];
                                NameUsers(BlackCardSpaces);
                                FunctionsDB.WritePointUserWin(indexRoom, cardSelect);
                                FunctionsDB.DeleteCardSelectDB(indexRoom);
                                btnConfirmWinner.Enabled = false;
                                room.NewRaund(indexRoom);
                                Timer1.Enabled = false;
                            }
                        }  
                    }
                    else
                    {
                        totalSeconds = Convert.ToInt16(Session["time2"]);
                        seconds = totalSeconds % 60;
                        minutes = totalSeconds / 60;
                        time = minutes + ":" + seconds;
                        lblTimerMaster.Text = time;
                    }
                }
            }

            else
            {
                totalSeconds = Convert.ToInt16(Session["time2"]);
                seconds = totalSeconds % 60;
                minutes = totalSeconds / 60;
                time = minutes + ":" + seconds;
                lblTimer.Text = time;
            }
        }
        else if (!room.IsMaster(Master.resultUser))
        {
            Session["time1"] = Convert.ToInt16(Session["time1"]) - 1;
            if (Convert.ToInt16(Session["time1"]) <= 0)
            {
                lblTimer.Text = "TimeOut!";

                if (!room.IsMaster(Master.resultUser))
                {
                    if (btnConfirmCardSelect.Enabled == true)
                    {
                        int spacesBlackCard = room.CheckStringBlackCard();

                        List<Cards> listCards = room.GetCardsWhite(Master.resultUser);

                        if (spacesBlackCard == 1)
                        {
                            int cardCount = RandomCard(listCards);
                            List<Cards> cardSelect = new List<Cards>();
                            cardSelect.Add(listCards[cardCount]);
                            room.DeleteCardForUser(Master.resultUser, listCards[cardCount].idCards);
                            room.UsersAndCards(cardSelect, indexRoom, Master.resultUser);
                            room.GenerateCardForUser(Master.resultUser);
                            btnConfirmCardSelect.Enabled = false;
                            Timer1.Enabled = false;
                        }

                        if (spacesBlackCard == 2)
                        {
                            int value = FunctionsDB.ReadCardsUser(indexRoom, Master.resultUser);

                            if (value == 1)
                            {
                                int cardCount = RandomCard(listCards);
                                List<Cards> cardSelect = new List<Cards>();
                                cardSelect.Add(listCards[cardCount]);
                                room.DeleteCardForUser(Master.resultUser, listCards[cardCount].idCards);
                                room.UsersAndCards(cardSelect, indexRoom, Master.resultUser);
                                room.GenerateCardForUser(Master.resultUser);
                                btnConfirmCardSelect.Enabled = false;
                                Timer1.Enabled = false;
                            }
                            else if (value == 0)
                            {                                                                
                                List<Cards> cardSelect = new List<Cards>();
                                
                                int cardCount = RandomCard(listCards);
                                cardSelect.Add(listCards[cardCount]);
                                room.DeleteCardForUser(Master.resultUser, listCards[cardCount].idCards);

                                int cardCount2 = RandomCard(listCards);
                                cardSelect.Add(listCards[cardCount2]);
                                room.DeleteCardForUser(Master.resultUser, listCards[cardCount2].idCards);
                                
                                room.GenerateCardForUser(Master.resultUser);
                                room.GenerateCardForUser(Master.resultUser);
                               
                                room.UsersAndCards(cardSelect, indexRoom, Master.resultUser);

                                btnConfirmCardSelect.Enabled = false;
                                Timer1.Enabled = false;
                            }
                        }

                        if (spacesBlackCard == 3)
                        {
                            int value = FunctionsDB.ReadCardsUser(indexRoom, Master.resultUser);
                            if (value == 1)
                            {
                                int cardCount = RandomCard(listCards);
                                List<Cards> cardSelect = new List<Cards>();
                                cardSelect.Add(listCards[cardCount]);
                                room.DeleteCardForUser(Master.resultUser, listCards[cardCount].idCards);
                                room.UsersAndCards(cardSelect, indexRoom, Master.resultUser);
                                room.GenerateCardForUser(Master.resultUser);
                                btnConfirmCardSelect.Enabled = false;
                                Timer1.Enabled = false;
                            }
                            else if (value == 2)
                            {
                                List<Cards> cardSelect = new List<Cards>();

                                int cardCount = RandomCard(listCards);
                                cardSelect.Add(listCards[cardCount]);
                                room.DeleteCardForUser(Master.resultUser, listCards[cardCount].idCards);

                                int cardCount2 = RandomCard(listCards);
                                cardSelect.Add(listCards[cardCount2]);
                                room.DeleteCardForUser(Master.resultUser, listCards[cardCount2].idCards);

                                room.GenerateCardForUser(Master.resultUser);
                                room.GenerateCardForUser(Master.resultUser);

                                room.UsersAndCards(cardSelect, indexRoom, Master.resultUser);

                                btnConfirmCardSelect.Enabled = false;
                                Timer1.Enabled = false;
                            }
                            else if (value == 0)
                            {
                                List<Cards> cardSelect = new List<Cards>();

                                int cardCount = RandomCard(listCards);
                                cardSelect.Add(listCards[cardCount]);
                                room.DeleteCardForUser(Master.resultUser, listCards[cardCount].idCards);

                                int cardCount2 = RandomCard(listCards);
                                cardSelect.Add(listCards[cardCount2]);
                                room.DeleteCardForUser(Master.resultUser, listCards[cardCount2].idCards);

                                int cardCount3 = RandomCard(listCards);
                                cardSelect.Add(listCards[cardCount3]);
                                room.DeleteCardForUser(Master.resultUser, listCards[cardCount3].idCards);

                                room.GenerateCardForUser(Master.resultUser);
                                room.GenerateCardForUser(Master.resultUser);
                                room.GenerateCardForUser(Master.resultUser);

                                room.UsersAndCards(cardSelect, indexRoom, Master.resultUser);

                                btnConfirmCardSelect.Enabled = false;
                                Timer1.Enabled = false;
                            }
                        }
                    }
                }
            }
            else
            {
                totalSeconds = Convert.ToInt16(Session["time1"]);
                seconds = totalSeconds % 60;
                minutes = totalSeconds / 60;
                time = minutes + ":" + seconds;
                lblTimer.Text = time;
            }
        }
    }
    
    public void ConfirmCardSelect()
    {
        Account user = Master.resultUser;

        Cards c = new Cards();
        
        if (btnWhite1.BackColor == System.Drawing.Color.LightBlue)
        {
            c.Text = btnWhite1.Text;
            c.idCards = Convert.ToInt32(btnWhite1.Attributes["value"]);
            btnWhite1.Attributes.Clear();
            btnWhite1.Text = "";
            room.DeleteCardForUser(Master.resultUser, c.idCards);
            FunctionsDB.WriteCardsSelect(user, c, indexRoom);
            btnWhite1.BackColor = System.Drawing.Color.White;
            btnWhite1.BorderColor = System.Drawing.Color.White;
        }
        if (btnWhite2.BackColor == System.Drawing.Color.LightBlue)
        {
            c.Text = btnWhite2.Text;
            c.idCards = Convert.ToInt32(btnWhite2.Attributes["value"]);
            btnWhite2.Attributes.Clear();
            btnWhite2.Text = "";
            room.DeleteCardForUser(Master.resultUser, c.idCards);
            FunctionsDB.WriteCardsSelect(user, c, indexRoom);
            btnWhite2.BackColor = System.Drawing.Color.White;
            btnWhite2.BorderColor = System.Drawing.Color.White;
        }
        if (btnWhite3.BackColor == System.Drawing.Color.LightBlue)
        {
            c.Text = btnWhite3.Text;
            c.idCards = Convert.ToInt32(btnWhite3.Attributes["value"]);
            btnWhite3.Attributes.Clear();
            btnWhite3.Text = "";
            room.DeleteCardForUser(Master.resultUser, c.idCards);
            FunctionsDB.WriteCardsSelect(user, c, indexRoom);
            btnWhite3.BackColor = System.Drawing.Color.White;
            btnWhite3.BorderColor = System.Drawing.Color.White;
        }
        if (btnWhite4.BackColor == System.Drawing.Color.LightBlue)
        {
            c.Text = btnWhite4.Text;
            c.idCards = Convert.ToInt32(btnWhite4.Attributes["value"]);
            btnWhite4.Attributes.Clear();
            btnWhite4.Text = "";
            room.DeleteCardForUser(Master.resultUser, c.idCards);
            FunctionsDB.WriteCardsSelect(user, c, indexRoom);
            btnWhite4.BackColor = System.Drawing.Color.White;
            btnWhite4.BorderColor = System.Drawing.Color.White;
        }
        if (btnWhite5.BackColor == System.Drawing.Color.LightBlue)
        {
            c.Text = btnWhite5.Text;
            c.idCards = Convert.ToInt32(btnWhite5.Attributes["value"]);
            btnWhite5.Attributes.Clear();
            btnWhite5.Text = "";
            room.DeleteCardForUser(Master.resultUser, c.idCards);
            FunctionsDB.WriteCardsSelect(user, c, indexRoom);
            btnWhite5.BackColor = System.Drawing.Color.White;
            btnWhite5.BorderColor = System.Drawing.Color.White;
        }
        if (btnWhite6.BackColor == System.Drawing.Color.LightBlue)
        {
            c.Text = btnWhite6.Text;
            c.idCards = Convert.ToInt32(btnWhite6.Attributes["value"]);
            btnWhite6.Attributes.Clear();
            btnWhite6.Text = "";
            room.DeleteCardForUser(Master.resultUser, c.idCards);
            FunctionsDB.WriteCardsSelect(user, c, indexRoom);
            btnWhite6.BackColor = System.Drawing.Color.White;
            btnWhite6.BorderColor = System.Drawing.Color.White;
        }
        if (btnWhite7.BackColor == System.Drawing.Color.LightBlue)
        {
            c.Text = btnWhite7.Text;
            c.idCards = Convert.ToInt32(btnWhite7.Attributes["value"]);
            btnWhite7.Attributes.Clear();
            btnWhite7.Text = "";
            room.DeleteCardForUser(Master.resultUser, c.idCards);
            FunctionsDB.WriteCardsSelect(user, c, indexRoom);
            btnWhite7.BackColor = System.Drawing.Color.White;
            btnWhite7.BorderColor = System.Drawing.Color.White;
        }
        if (btnWhite8.BackColor == System.Drawing.Color.LightBlue)
        {
            c.Text = btnWhite8.Text;
            c.idCards = Convert.ToInt32(btnWhite8.Attributes["value"]);
            btnWhite8.Attributes.Clear();
            btnWhite8.Text = "";
            room.DeleteCardForUser(Master.resultUser, c.idCards);
            FunctionsDB.WriteCardsSelect(user, c, indexRoom);
            btnWhite8.BackColor = System.Drawing.Color.White;
            btnWhite8.BorderColor = System.Drawing.Color.White;
        }
        if (btnWhite9.BackColor == System.Drawing.Color.LightBlue)
        {
            c.Text = btnWhite9.Text;
            c.idCards = Convert.ToInt32(btnWhite9.Attributes["value"]);
            btnWhite9.Attributes.Clear();
            btnWhite9.Text = "";
            room.DeleteCardForUser(Master.resultUser, c.idCards);
            FunctionsDB.WriteCardsSelect(user, c, indexRoom);
            btnWhite9.BackColor = System.Drawing.Color.White;
            btnWhite9.BorderColor = System.Drawing.Color.White;
        }
        if (btnWhite10.BackColor == System.Drawing.Color.LightBlue)
        {
            c.Text = btnWhite10.Text;
            c.idCards = Convert.ToInt32(btnWhite10.Attributes["value"]);
            btnWhite10.Attributes.Clear();
            btnWhite10.Text = "";
            room.DeleteCardForUser(Master.resultUser, c.idCards);
            FunctionsDB.WriteCardsSelect(user, c, indexRoom);
            btnWhite10.BackColor = System.Drawing.Color.White;
            btnWhite10.BorderColor = System.Drawing.Color.White;
        }
    }
    
    protected void btnConfirmCardSelect_Click(object sender, EventArgs e)
    {
        Account user = Master.resultUser;
       
        ConfirmCardSelect();

        int spacesBlackCard = room.CheckStringBlackCard();
       
        if (spacesBlackCard == 1)
        {
            int value = FunctionsDB.ReadCardsUser(indexRoom, Master.resultUser);

            if (value == 1)
            {
                Timer1.Enabled = false;

                lblTimer.Text = "TimeOut!";

                btnConfirmCardSelect.Enabled = false;

                NewCardWhite();
            }
            else if (value == 0)
            {
                string script = "alert(\"Devi selezionare le carte!\");";
                ScriptManager.RegisterStartupScript(this, GetType(), "", script, true);
                btnConfirmCardSelect.Enabled = true;
            }     
        }

        if (spacesBlackCard == 2)
        {
            int value = FunctionsDB.ReadCardsUser(indexRoom, Master.resultUser);

            if (value == 2)
            {
                Timer1.Enabled = false;

                lblTimer.Text = "TimeOut!";

                btnConfirmCardSelect.Enabled = false;

                NewCardWhite();
            }
            else if(value == 1)
            {
                string script = "alert(\"Devi selezionare ancora 1 carta!\");";
                ScriptManager.RegisterStartupScript(this, GetType(), "", script, true);
                btnConfirmCardSelect.Enabled = true;
            }    
            else if(value == 0)
            {
                string script = "alert(\"Devi selezionare le carte!\");";
                ScriptManager.RegisterStartupScript(this, GetType(), "", script, true);
                btnConfirmCardSelect.Enabled = true;
            }    
        }

        if (spacesBlackCard == 3)
        {
            int value = FunctionsDB.ReadCardsUser(indexRoom, Master.resultUser);
            
            if (value == 3)
            {
                Timer1.Enabled = false;

                lblTimer.Text = "TimeOut!";

                btnConfirmCardSelect.Enabled = false;

                NewCardWhite();
            }
            else
            {
                if (value == 1)
                {
                    string script = "alert(\"Devi selezionare ancora 2 carta!\");";
                    ScriptManager.RegisterStartupScript(this, GetType(), "", script, true);
                    btnConfirmCardSelect.Enabled = true;
                }
                else if (value == 2)
                {
                    string script = "alert(\"Devi selezionare ancora 1 carta!\");";
                    ScriptManager.RegisterStartupScript(this, GetType(), "", script, true);
                    btnConfirmCardSelect.Enabled = true;
                }
                else if (value == 0)
                {
                    string script = "alert(\"Devi selezionare le carte!\");";
                    ScriptManager.RegisterStartupScript(this, GetType(), "", script, true);
                    btnConfirmCardSelect.Enabled = true;
                }  
            }
        } 
    }
    
    protected void btnConfirmWinner_Click(object sender, EventArgs e)
    {
        Cards CardSelect = new Cards();

        int spacesBlackCard = room.CheckStringBlackCard();

        if (room.UsersNotMaster(indexRoom) == 4)
        {
            if (spacesBlackCard == 1)
            {
                if (btnWhite1.BackColor == System.Drawing.Color.LightBlue)
                {
                    Cards c = new Cards();
                    c.Text = btnWhite1.Text;
                    c.idCards = Convert.ToInt32(btnWhite1.Attributes["value"]);
                    CardSelect = c;
                }
                if (btnWhite2.BackColor == System.Drawing.Color.LightBlue)
                {
                    Cards c = new Cards();
                    c.Text = btnWhite2.Text;
                    c.idCards = Convert.ToInt32(btnWhite2.Attributes["value"]);
                    CardSelect = c;
                }
                if (btnWhite3.BackColor == System.Drawing.Color.LightBlue)
                {
                    Cards c = new Cards();
                    c.Text = btnWhite3.Text;
                    c.idCards = Convert.ToInt32(btnWhite3.Attributes["value"]);
                    CardSelect = c;
                }
                if (btnWhite4.BackColor == System.Drawing.Color.LightBlue)
                {
                    Cards c = new Cards();
                    c.Text = btnWhite4.Text;
                    c.idCards = Convert.ToInt32(btnWhite4.Attributes["value"]);
                    CardSelect = c;
                }

                lblUser1.Visible = true;
                lblUser2.Visible = true;
                lblUser3.Visible = true;
                lblUser4.Visible = true;
            }

            if (spacesBlackCard == 2)
            {
                if (btnWhite1.BackColor == System.Drawing.Color.LightBlue)
                {
                    Cards c = new Cards();
                    c.Text = btnWhite1.Text;
                    c.idCards = Convert.ToInt32(btnWhite1.Attributes["value"]);
                    CardSelect = c;
                }

                if (btnWhite3.BackColor == System.Drawing.Color.LightBlue)
                {
                    Cards c = new Cards();
                    c.Text = btnWhite3.Text;
                    c.idCards = Convert.ToInt32(btnWhite3.Attributes["value"]);
                    CardSelect = c;
                }

                if (btnWhite5.BackColor == System.Drawing.Color.LightBlue)
                {
                    Cards c = new Cards();
                    c.Text = btnWhite5.Text;
                    c.idCards = Convert.ToInt32(btnWhite5.Attributes["value"]);
                    CardSelect = c;
                }

                if (btnWhite7.BackColor == System.Drawing.Color.LightBlue)
                {
                    Cards c = new Cards();
                    c.Text = btnWhite7.Text;
                    c.idCards = Convert.ToInt32(btnWhite7.Attributes["value"]);
                    CardSelect = c;
                }
                lblUser1.Visible = true;
                lblUser2.Visible = true;
                lblUser3.Visible = true;
                lblUser4.Visible = true;
                lblUser5.Visible = true;
                lblUser6.Visible = true;
                lblUser7.Visible = true;
                lblUser8.Visible = true;
            }

            if (spacesBlackCard == 3)
            {
                if (btnWhite1.BackColor == System.Drawing.Color.LightBlue)
                {
                    Cards c = new Cards();
                    c.Text = btnWhite1.Text;
                    c.idCards = Convert.ToInt32(btnWhite1.Attributes["value"]);
                    CardSelect = c;
                }

                if (btnWhite4.BackColor == System.Drawing.Color.LightBlue)
                {
                    Cards c = new Cards();
                    c.Text = btnWhite4.Text;
                    c.idCards = Convert.ToInt32(btnWhite4.Attributes["value"]);
                    CardSelect = c;
                }

                if (btnWhite7.BackColor == System.Drawing.Color.LightBlue)
                {
                    Cards c = new Cards();
                    c.Text = btnWhite7.Text;
                    c.idCards = Convert.ToInt32(btnWhite7.Attributes["value"]);
                    CardSelect = c;
                }

                if (btnWhite10.BackColor == System.Drawing.Color.LightBlue)
                {
                    Cards c = new Cards();
                    c.Text = btnWhite10.Text;
                    c.idCards = Convert.ToInt32(btnWhite10.Attributes["value"]);
                    CardSelect = c;
                }

                lblUser1.Visible = true;
                lblUser2.Visible = true;
                lblUser3.Visible = true;
                lblUser4.Visible = true;
                lblUser5.Visible = true;
                lblUser6.Visible = true;
                lblUser7.Visible = true;
                lblUser8.Visible = true;
                lblUser9.Visible = true;
                lblUser10.Visible = true;
                lblUser11.Visible = true;
                lblUser12.Visible = true;
            }
        }
        NameUsers(spacesBlackCard);
        
        FunctionsDB.WritePointUserWin(indexRoom, CardSelect);

        Account userWin = FunctionsDB.ReadUserWin(indexRoom, CardSelect);

        FunctionsDB.DeleteCardSelectDB(indexRoom);

        btnConfirmWinner.Enabled = false;

        room.NewRaund(indexRoom);
        
        Timer1.Enabled = false;

        /*string script = "alert(\"" + userWin.Username + "\");";
        ScriptManager.RegisterStartupScript(this, GetType(), "Il vincitore è: ", script, true);*/

        lblTimerMaster.Text = "TimeOut!";         
    }

    protected void NameUsers(int spacesBlackCard)
    {
        List<Account> usernames = FunctionsDB.ReadUsernames(indexRoom);

        if (spacesBlackCard == 1)
        {
            if (room.UsersNotMaster(indexRoom) == 4)
            {
                lblUser1.Attributes.Add("value", usernames[0].idAccount.ToString());
                lblUser1.Text = usernames[0].Username;

                lblUser2.Attributes.Add("value", usernames[1].idAccount.ToString());
                lblUser2.Text = usernames[1].Username;

                lblUser3.Attributes.Add("value", usernames[2].idAccount.ToString());
                lblUser3.Text = usernames[2].Username;

                /*lblUser4.Attributes.Add("value", usernames[3].idAccount.ToString());
                lblUser4.Text = usernames[3].Username;*/
            }

            if (room.UsersNotMaster(indexRoom) == 2)
            {
                lblUser1.Attributes.Add("value", usernames[0].idAccount.ToString());
                lblUser1.Text = usernames[0].Username;

                lblUser2.Attributes.Add("value", usernames[1].idAccount.ToString());
                lblUser2.Text = usernames[1].Username;

                /*lblUser3.Attributes.Add("value", usernames[2].idAccount.ToString());
                lblUser3.Text = usernames[2].Username;*/
            }
        }

        if (spacesBlackCard == 2)
        {
            if (room.UsersNotMaster(indexRoom) == 4)
            {
                lblUser1.Attributes.Add("value", usernames[0].idAccount.ToString());
                lblUser1.Text = usernames[0].Username;

                lblUser2.Attributes.Add("value", usernames[1].idAccount.ToString());
                lblUser2.Text = usernames[1].Username;

                lblUser3.Attributes.Add("value", usernames[2].idAccount.ToString());
                lblUser3.Text = usernames[2].Username;

                lblUser4.Attributes.Add("value", usernames[3].idAccount.ToString());
                lblUser4.Text = usernames[3].Username;

                lblUser5.Attributes.Add("value", usernames[4].idAccount.ToString());
                lblUser5.Text = usernames[4].Username;

                lblUser6.Attributes.Add("value", usernames[5].idAccount.ToString());
                lblUser6.Text = usernames[5].Username;

                /* lblUser7.Attributes.Add("value", usernames[6].idAccount.ToString());
                lblUser7.Text = usernames[6].Username;

                lblUser8.Attributes.Add("value", usernames[7].idAccount.ToString());
                lblUser8.Text = usernames[7].Username;*/
            }

            if (room.UsersNotMaster(indexRoom) == 2)
            {
                lblUser1.Attributes.Add("value", usernames[0].idAccount.ToString());
                lblUser1.Text = usernames[0].Username;

                lblUser2.Attributes.Add("value", usernames[1].idAccount.ToString());
                lblUser2.Text = usernames[1].Username;

                lblUser3.Attributes.Add("value", usernames[2].idAccount.ToString());
                lblUser3.Text = usernames[2].Username;

                lblUser4.Attributes.Add("value", usernames[3].idAccount.ToString());
                lblUser4.Text = usernames[3].Username;

                /*lblUser5.Attributes.Add("value", usernames[4].idAccount.ToString());
                lblUser5.Text = usernames[4].Username;

                lblUser6.Attributes.Add("value", usernames[5].idAccount.ToString());
                lblUser6.Text = usernames[5].Username;*/
            }
        }

        if (spacesBlackCard == 3)
        {
            if (room.UsersNotMaster(indexRoom) == 4)
            {
                lblUser1.Attributes.Add("value", usernames[0].idAccount.ToString());
                lblUser1.Text = usernames[0].Username;

                lblUser2.Attributes.Add("value", usernames[1].idAccount.ToString());
                lblUser2.Text = usernames[1].Username;

                lblUser3.Attributes.Add("value", usernames[2].idAccount.ToString());
                lblUser3.Text = usernames[2].Username;

                lblUser4.Attributes.Add("value", usernames[3].idAccount.ToString());
                lblUser4.Text = usernames[3].Username;

                lblUser5.Attributes.Add("value", usernames[4].idAccount.ToString());
                lblUser5.Text = usernames[4].Username;

                lblUser6.Attributes.Add("value", usernames[5].idAccount.ToString());
                lblUser6.Text = usernames[5].Username;

                lblUser7.Attributes.Add("value", usernames[6].idAccount.ToString());
                lblUser7.Text = usernames[6].Username;

                lblUser8.Attributes.Add("value", usernames[7].idAccount.ToString());
                lblUser8.Text = usernames[7].Username;

                lblUser9.Attributes.Add("value", usernames[8].idAccount.ToString());
                lblUser9.Text = usernames[8].Username;

                /*lblUser10.Attributes.Add("value", usernames[9].idAccount.ToString());
                lblUser10.Text = usernames[9].Username;

                lblUser11.Attributes.Add("value", usernames[10].idAccount.ToString());
                lblUser11.Text = usernames[10].Username;

                lblUser12.Attributes.Add("value", usernames[11].idAccount.ToString());
                lblUser12.Text = usernames[1].Username;*/
            }

            if (room.UsersNotMaster(indexRoom) == 2)
            {
                lblUser1.Attributes.Add("value", usernames[0].idAccount.ToString());
                lblUser1.Text = usernames[0].Username;

                lblUser2.Attributes.Add("value", usernames[1].idAccount.ToString());
                lblUser2.Text = usernames[1].Username;

                lblUser3.Attributes.Add("value", usernames[2].idAccount.ToString());
                lblUser3.Text = usernames[2].Username;

                lblUser4.Attributes.Add("value", usernames[3].idAccount.ToString());
                lblUser4.Text = usernames[3].Username;

                lblUser5.Attributes.Add("value", usernames[4].idAccount.ToString());
                lblUser5.Text = usernames[4].Username;

                lblUser6.Attributes.Add("value", usernames[5].idAccount.ToString());
                lblUser6.Text = usernames[5].Username;

                /*lblUser7.Attributes.Add("value", usernames[6].idAccount.ToString());
                lblUser7.Text = usernames[6].Username;

                lblUser8.Attributes.Add("value", usernames[7].idAccount.ToString());
                lblUser8.Text = usernames[7].Username;

                lblUser9.Attributes.Add("value", usernames[8].idAccount.ToString());
                lblUser9.Text = usernames[8].Username;*/
            }
        }

    }
    protected void NewCardWhite()
    {
        if (btnWhite1.Text == "")
        {
            if (btnWhite1.BackColor == System.Drawing.Color.LightBlue)
            {
                btnWhite1.BorderColor = System.Drawing.Color.White;
                btnWhite1.BackColor = System.Drawing.Color.White;
            }
           
            room.GenerateCardForUser(Master.resultUser);
            Cards textCard = room.GetNewCardWhite(Master.resultUser);
            
            btnWhite1.Attributes.Add("value", textCard.idCards.ToString());
            btnWhite1.Text = textCard.Text;
            
        }
        if (btnWhite2.Text == "")
        {
            if (btnWhite2.BackColor == System.Drawing.Color.LightBlue)
            {
                btnWhite2.BorderColor = System.Drawing.Color.White;
                btnWhite2.BackColor = System.Drawing.Color.White;
            }
      
            room.GenerateCardForUser(Master.resultUser);
            Cards textCard = room.GetNewCardWhite(Master.resultUser);

            btnWhite2.Attributes.Add("value", textCard.idCards.ToString());
            btnWhite2.Text = textCard.Text;
        }
        if (btnWhite3.Text == "")
        {
            if (btnWhite3.BackColor == System.Drawing.Color.LightBlue)
            {
                btnWhite3.BorderColor = System.Drawing.Color.White;
                btnWhite3.BackColor = System.Drawing.Color.White;
            }
            room.GenerateCardForUser(Master.resultUser);
            Cards textCard = room.GetNewCardWhite(Master.resultUser);

            btnWhite3.Attributes.Add("value", textCard.idCards.ToString());
            btnWhite3.Text = textCard.Text;
        }
        if (btnWhite4.Text == "")
        {
            if (btnWhite4.BackColor == System.Drawing.Color.LightBlue)
            {
                btnWhite4.BorderColor = System.Drawing.Color.White;
                btnWhite4.BackColor = System.Drawing.Color.White;
            }
            room.GenerateCardForUser(Master.resultUser);
            Cards textCard = room.GetNewCardWhite(Master.resultUser);

            btnWhite4.Attributes.Add("value", textCard.idCards.ToString());
            btnWhite4.Text = textCard.Text;
        }
        if (btnWhite5.Text == "")
        {
            if (btnWhite5.BackColor == System.Drawing.Color.LightBlue)
            {
                btnWhite5.BorderColor = System.Drawing.Color.White;
                btnWhite5.BackColor = System.Drawing.Color.White;
            }
            room.GenerateCardForUser(Master.resultUser);
            Cards textCard = room.GetNewCardWhite(Master.resultUser);

            btnWhite5.Attributes.Add("value", textCard.idCards.ToString());
            btnWhite5.Text = textCard.Text;
        }
        if (btnWhite6.Text == "")
        {
            if (btnWhite6.BackColor == System.Drawing.Color.LightBlue)
            {
                btnWhite6.BorderColor = System.Drawing.Color.White;
                btnWhite6.BackColor = System.Drawing.Color.White;
            }
            room.GenerateCardForUser(Master.resultUser);
            Cards textCard = room.GetNewCardWhite(Master.resultUser);

            btnWhite6.Attributes.Add("value", textCard.idCards.ToString());
            btnWhite6.Text = textCard.Text;
        }
        if (btnWhite7.Text == "")
        {
            if (btnWhite7.BackColor == System.Drawing.Color.LightBlue)
            {
                btnWhite7.BorderColor = System.Drawing.Color.White;
                btnWhite7.BackColor = System.Drawing.Color.White;
            }
            room.GenerateCardForUser(Master.resultUser);
            Cards textCard = room.GetNewCardWhite(Master.resultUser);

            btnWhite7.Attributes.Add("value", textCard.idCards.ToString());
            btnWhite7.Text = textCard.Text;
        }
        if (btnWhite8.Text == "")
        {
            if (btnWhite8.BackColor == System.Drawing.Color.LightBlue)
            {
                btnWhite8.BorderColor = System.Drawing.Color.White;
                btnWhite8.BackColor = System.Drawing.Color.White;
            }
            room.GenerateCardForUser(Master.resultUser);
            Cards textCard = room.GetNewCardWhite(Master.resultUser);

            btnWhite8.Attributes.Add("value", textCard.idCards.ToString());
            btnWhite8.Text = textCard.Text;
        }
        if (btnWhite9.Text == "")
        {
            if (btnWhite9.BackColor == System.Drawing.Color.LightBlue)
            {
                btnWhite9.BorderColor = System.Drawing.Color.White;
                btnWhite9.BackColor = System.Drawing.Color.White;
            }
            room.GenerateCardForUser(Master.resultUser);
            Cards textCard = room.GetNewCardWhite(Master.resultUser);

            btnWhite9.Attributes.Add("value", textCard.idCards.ToString());
            btnWhite9.Text = textCard.Text;
        }
        if (btnWhite10.Text == "")
        {
            if (btnWhite10.BackColor == System.Drawing.Color.LightBlue)
            {
                btnWhite10.BorderColor = System.Drawing.Color.White;
                btnWhite10.BackColor = System.Drawing.Color.White;
            }
            room.GenerateCardForUser(Master.resultUser);
            Cards textCard = room.GetNewCardWhite(Master.resultUser);

            btnWhite10.Attributes.Add("value", textCard.idCards.ToString());
            btnWhite10.Text = textCard.Text;
        }
    }
   
    protected void btnWhite1_Click(object sender, EventArgs e)
    {
        if (btnWhite1.BackColor == System.Drawing.Color.LightBlue)
        {
            btnWhite1.BorderColor = System.Drawing.Color.White;
            btnWhite1.BackColor = System.Drawing.Color.White;
        }
        else
        {
            btnWhite1.BorderColor = System.Drawing.Color.LightBlue;
            btnWhite1.BackColor = System.Drawing.Color.LightBlue;
        }
    }

    protected void btnWhite2_Click(object sender, EventArgs e)
    {
        if(btnWhite2.BackColor == System.Drawing.Color.LightBlue)
        {
            btnWhite2.BorderColor = System.Drawing.Color.White;
            btnWhite2.BackColor = System.Drawing.Color.White;
        }
        else
        {
            btnWhite2.BorderColor = System.Drawing.Color.LightBlue;
            btnWhite2.BackColor = System.Drawing.Color.LightBlue;
        }
    }

    protected void btnWhite3_Click(object sender, EventArgs e)
    {
        if(btnWhite3.BackColor == System.Drawing.Color.LightBlue)
        {
            btnWhite3.BorderColor = System.Drawing.Color.White;
            btnWhite3.BackColor = System.Drawing.Color.White;
        }
        else
        {
            btnWhite3.BorderColor = System.Drawing.Color.LightBlue;
            btnWhite3.BackColor = System.Drawing.Color.LightBlue;
        }
    }

    protected void btnWhite4_Click(object sender, EventArgs e)
    {
        if(btnWhite4.BackColor == System.Drawing.Color.LightBlue)
        {
            btnWhite4.BorderColor = System.Drawing.Color.White;
            btnWhite4.BackColor = System.Drawing.Color.White;   
        }
        else
        {
            btnWhite4.BorderColor = System.Drawing.Color.LightBlue;
            btnWhite4.BackColor = System.Drawing.Color.LightBlue;
        }
    }

    protected void btnWhite5_Click(object sender, EventArgs e)
    {    
        if(btnWhite5.BackColor == System.Drawing.Color.LightBlue)
        {
            btnWhite5.BorderColor = System.Drawing.Color.White;
            btnWhite5.BackColor = System.Drawing.Color.White;
        }
        else
        {
            btnWhite5.BorderColor = System.Drawing.Color.LightBlue;
            btnWhite5.BackColor = System.Drawing.Color.LightBlue;
        }
    }

    protected void btnWhite6_Click(object sender, EventArgs e)
    {
        if(btnWhite6.BackColor == System.Drawing.Color.LightBlue)
        {
            btnWhite6.BorderColor = System.Drawing.Color.White;
            btnWhite6.BackColor = System.Drawing.Color.White;
        }
        else
        {
            btnWhite6.BorderColor = System.Drawing.Color.LightBlue;
            btnWhite6.BackColor = System.Drawing.Color.LightBlue;
        }
    }

    protected void btnWhite7_Click(object sender, EventArgs e)
    {
        if(btnWhite7.BackColor == System.Drawing.Color.LightBlue)
        {
            btnWhite7.BorderColor = System.Drawing.Color.White;
            btnWhite7.BackColor = System.Drawing.Color.White;
        }
        else
        {
            btnWhite7.BorderColor = System.Drawing.Color.LightBlue;
            btnWhite7.BackColor = System.Drawing.Color.LightBlue;
        }
    }

    protected void btnWhite8_Click(object sender, EventArgs e)
    {
        if(btnWhite8.BackColor == System.Drawing.Color.LightBlue)
        {
            btnWhite8.BorderColor = System.Drawing.Color.White;
            btnWhite8.BackColor = System.Drawing.Color.White;
        }
        else
        {
            btnWhite8.BorderColor = System.Drawing.Color.LightBlue;
            btnWhite8.BackColor = System.Drawing.Color.LightBlue;
        }
    }

    protected void btnWhite9_Click(object sender, EventArgs e)
    {
        if(btnWhite9.BackColor == System.Drawing.Color.LightBlue)
        {
            btnWhite9.BorderColor = System.Drawing.Color.White;
            btnWhite9.BackColor = System.Drawing.Color.White;
        }
        else
        {
            btnWhite9.BorderColor = System.Drawing.Color.LightBlue;
            btnWhite9.BackColor = System.Drawing.Color.LightBlue;
        }
    }

    protected void btnWhite10_Click(object sender, EventArgs e)
    {
        if(btnWhite10.BackColor == System.Drawing.Color.LightBlue)
        {
            btnWhite10.BorderColor = System.Drawing.Color.White;
            btnWhite10.BackColor = System.Drawing.Color.White;
        }
        else
        {
            btnWhite10.BorderColor = System.Drawing.Color.LightBlue;
            btnWhite10.BackColor = System.Drawing.Color.LightBlue;
        }
    }

    protected void Timer2_Tick(object sender, EventArgs e)
    {
        Session["time3"] = Convert.ToInt16(Session["time3"]) - 1;
        if (Convert.ToInt16(Session["time3"]) <= 0)
        {
            Response.Redirect("~/game.aspx");     
        }
        else
        {
            totalSeconds = Convert.ToInt16(Session["time3"]);
            seconds = totalSeconds % 60;
            minutes = totalSeconds / 60;
            time = minutes + ":" + seconds;
            if (!room.IsMaster(Master.resultUser))
            {
                if(lblTimer.Text == "TimeOut!")
                {
                    Timer1.Enabled = false;
                }
            }
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" type="text/css" href="css/game.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container game-container">
        <div>
            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
            <asp:Timer ID="Timer1" runat="server" Interval="1000" OnTick="Timer1_Tick"></asp:Timer>
            <asp:Timer ID="Timer2" runat="server" OnTick="Timer2_Tick" Interval="30000" Enabled="True">
            </asp:Timer>
        </div>
        <asp:UpdatePanel ID="Pannello" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:Label ID="lblTimer" runat="server"></asp:Label>
                <asp:Label ID="lblTimerMaster" runat="server"></asp:Label>
                <br />
                <br />
                <asp:Label ID="lblPoints" runat="server"></asp:Label>
                <div class="row">
                    <div class="col-md-2">
                        <div class="card-black-container">
                            <div class="black-card">
                                <asp:Label ID="lblBlack" runat="server"></asp:Label>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-9">
                        <div class="row">
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite1" CssClass="card-container white-card text-white" runat="server" Text="" OnClick="btnWhite1_Click" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser1" runat="server" Text="Label"></asp:Label>
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite2" CssClass="card-container white-card text-white" runat="server" Text="" OnClick="btnWhite2_Click" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser2" runat="server" Text="Label"></asp:Label>
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite3" CssClass="card-container white-card text-white" runat="server" Text="" OnClick="btnWhite3_Click" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser3" runat="server" Text="Label"></asp:Label>
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite4" CssClass="card-container white-card text-white" runat="server" Text="" OnClick="btnWhite4_Click" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser4" runat="server" Text="Label"></asp:Label>
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite5" CssClass="card-container white-card text-white" runat="server" Text="" OnClick="btnWhite5_Click" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser5" runat="server" Text="Label"></asp:Label>
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite6" CssClass="card-container white-card text-white" runat="server" Text="" OnClick="btnWhite6_Click" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser6" runat="server" Text="Label"></asp:Label>
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite7" CssClass="card-container white-card text-white" runat="server" Text="" OnClick="btnWhite7_Click" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser7" runat="server" Text="Label"></asp:Label>
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite8" CssClass="card-container white-card text-white" runat="server" Text="" OnClick="btnWhite8_Click" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser8" runat="server" Text="Label"></asp:Label>
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite9" CssClass="card-container white-card text-white" runat="server" Text="" OnClick="btnWhite9_Click" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser9" runat="server" Text="Label"></asp:Label>
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite10" CssClass="card-container white-card text-white" runat="server" Text="" OnClick="btnWhite10_Click" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser10" runat="server" Text="Label"></asp:Label>
                                </div>
                            </div>
                            <asp:Button ID="btnConfirmCardSelect" runat="server" Text="Conferma" OnClick="btnConfirmCardSelect_Click" />
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite11" CssClass="card-container white-card text-white" runat="server" Text="" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser11" runat="server" Text="Label"></asp:Label>
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite12" CssClass="card-container white-card text-white" runat="server" Text="" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser12" runat="server" Text="Label"></asp:Label>
                                </div>
                            </div>
                            <asp:Button ID="btnConfirmWinner" runat="server" Text="Conferma" OnClick="btnConfirmWinner_Click" />
                        </div>
                    </div>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="Timer1" EventName="Tick" />
            </Triggers>
        </asp:UpdatePanel>
    </div>
</asp:Content>
