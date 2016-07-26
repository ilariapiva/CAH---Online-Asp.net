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
        
        lblPoints.Text = "Score: " + points;
        
        Round rounds = FunctionsDB.ReadRounds(indexRoom);
        lblRounds.Text = "Number of round: " + rounds.numberRound;

        if (!Page.IsPostBack)
        {
            stateChanged = true;

            //Session["time1"] = DateTime.Now.AddSeconds(50);
            //Session["time2"] = DateTime.Now.AddSeconds(80);
            //Session["time3"] = DateTime.Now.AddSeconds(83);
            //Session["time4"] = DateTime.Now.AddSeconds(40);
            //Session["time5"] = DateTime.Now.AddSeconds(115);
            //Session["time1"] = DateTime.Now.AddSeconds(70);
            //Session["time2"] = DateTime.Now.AddSeconds(130);
            //Session["time3"] = DateTime.Now.AddSeconds(133);
            //Session["time4"] = DateTime.Now.AddSeconds(60);
            //Session["time5"] = DateTime.Now.AddSeconds(193);   
            Session["time1"] = 50;
            Session["time2"] = 40;
            Session["time3"] = 3;
            Session["time4"] = 40;
            Session["time5"] = 150;
            Session["time6"] = 1;        
        }
         
        if (stateChanged)
        {
            Round round = FunctionsDB.ReadRounds(indexRoom);
            if (round.numberRound > 3)
            {
                UpdateMatches();
                room.DeleteCardsUser(Master.resultUser);
                room.DeleteUser(indexRoom, Master.resultUser);
                FunctionsDB.DeleteUserInGame(indexRoom, Master.resultUser);
                FunctionsDB.DeleteCardsWhite(indexRoom, Master.resultUser);
                //FunctionsDB.ResetRounds(indexRoom);
                //FunctionsDB.ResetTimer(indexRoom);
                if (FunctionsDB.CheckCardsUser(indexRoom, Master.resultUser))
                {
                    FunctionsDB.DeleteCardSelectUser(indexRoom, Master.resultUser);
                }
                if(FunctionsDB.CheckDeleteCardsBlack(indexRoom))
                {
                    FunctionsDB.DeleteCardsBlack(indexRoom);
                }
                Response.Redirect("~/index.aspx");
            }
            //se l'utente è il master visualizzo solo la carta master 
            if (room.IsMaster(Master.resultUser, indexRoom))
            {
                Timer1.Enabled = true;
                //lblTimerXText.Text = "In attesa che i giocatori scelgano le carte bianche..";
                lblTimerXText.Text = "Waiting for players to choose white cards..";
                btnConfirmCardSelect.Visible = false;
                btnConfirmCardSelect.Enabled = false;
                btnConfirmWinner.Visible = false;

                blackCard = room.GetCardBlack(indexRoom);
                lblBlack.Attributes.Add("value", blackCard.idCards.ToString());
                lblBlack.Text = blackCard.Text;

                FunctionsDB.UpdateCardsBlack(indexRoom, blackCard);
                int spacesBlackCard = room.CheckStringBlackCard(indexRoom);

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
            if (!room.IsMaster(Master.resultUser, indexRoom))
            {
                Timer4.Enabled = true;
                //lblTimerXText.Text = "Timer per la scelta delle carte bianche: ";
                lblTimerXText.Text = "Timer for choosing the white cards: ";
                lblTimerMaster.Visible = false;
                btnConfirmWinner.Visible = false;
                btnConfirmWinner.Enabled = false;

                blackCard = room.GetCardBlack(indexRoom);
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

    //Questa funzione permette di aggiornare i dati relativi alle partite vinte, perse e pareggiate
    protected void UpdateMatches()
    {
        int numberUserPointsMax = FunctionsDB.GetNUserPointsMax(indexRoom);
        int maxPoint = FunctionsDB.GetMaxPoint(indexRoom);

        List<Account> listUserWin = new List<Account>();
        listUserWin = FunctionsDB.GetUsername(indexRoom, maxPoint);

        foreach(Account u in listUserWin)
        {
            if (u.Username == Master.resultUser.Username)
            {
                if (numberUserPointsMax == 1)
                {
                    FunctionsDB.UpdateMatchesWon(Master.resultUser);
                }
                else if (numberUserPointsMax > 1)
                {
                    FunctionsDB.UpdateMatchesEqualizedd(Master.resultUser);
                }
            }
        }
        
        List<Account> listUserLose = new List<Account>();
        listUserLose = FunctionsDB.GetUserLose(indexRoom, maxPoint);

        foreach (Account u in listUserLose)
        {
            if (u.Username == Master.resultUser.Username)
            {
                if (numberUserPointsMax == 1)
                {
                    FunctionsDB.UpdateMatchesMissed(Master.resultUser);
                }
            }
        }
    }
    
    //Questa funzione permette di confermare le carte selezionate dall'utente
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
            FunctionsDB.UpdateCardsWhite(indexRoom, c);
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
            FunctionsDB.UpdateCardsWhite(indexRoom, c);
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
            FunctionsDB.UpdateCardsWhite(indexRoom, c);
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
            FunctionsDB.UpdateCardsWhite(indexRoom, c);
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
            FunctionsDB.UpdateCardsWhite(indexRoom, c);
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
            FunctionsDB.UpdateCardsWhite(indexRoom, c);
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
            FunctionsDB.UpdateCardsWhite(indexRoom, c);
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
            FunctionsDB.UpdateCardsWhite(indexRoom, c);
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
            FunctionsDB.UpdateCardsWhite(indexRoom, c);
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
            FunctionsDB.UpdateCardsWhite(indexRoom, c);
            btnWhite10.BackColor = System.Drawing.Color.White;
            btnWhite10.BorderColor = System.Drawing.Color.White;
        }
    }
    
    protected void btnConfirmCardSelect_Click(object sender, EventArgs e)
    {
        Account user = Master.resultUser;
       
        ConfirmCardSelect();

        int spacesBlackCard = room.CheckStringBlackCard(indexRoom);
       
        if (spacesBlackCard == 1)
        {
            int value = FunctionsDB.ReadNCardSelect(indexRoom, Master.resultUser);

            if (value == 1)
            {
                lblTimer.Text = "TimeOut!";
                //lblTimerXText.Text = "Aspetta! Il master sta scegliendo il vincitore";
                lblTimerXText.Text = "Wait! The master is choosing the winner.";
                btnConfirmCardSelect.Enabled = false;
                NewCardWhite();
                int r = 0;
                FunctionsDB.UpdateNewRound(indexRoom, r);
                Timer4.Dispose();
                Timer4.Enabled = false;
                Timer5.Enabled = true;  
                lblTimer.Visible = false;       
            }
            else
            {
                if (value == 0)
                {
                    //string script = "alert(\"Devi selezionare 1 carta prima di cliccare su conferma!\");";
                    string script = "alert(\"You must select 1 card before clicking to confirm!\");";
                    //ScriptManager.RegisterStartupScript(this, GetType(), "", script, true);
                    ScriptManager.RegisterClientScriptBlock((sender as Control), this.GetType(), "alert", script, true);
                    btnConfirmCardSelect.Enabled = true;
                }
                if(value > 1)
                {
                    //string script = "alert(\"Devi selezionare solo 1 carta!\");";
                    string script = "alert(\"You must select only 1 card!\");";
                    //ScriptManager.RegisterStartupScript(this, GetType(), "", script, true);
                    ScriptManager.RegisterClientScriptBlock((sender as Control), this.GetType(), "alert", script, true);
                    btnConfirmCardSelect.Enabled = true;
                    FunctionsDB.DeleteCardSelectUser(indexRoom, Master.resultUser);
                }
            }         
        }

        if (spacesBlackCard == 2)
        {
            int value = FunctionsDB.ReadNCardSelect(indexRoom, Master.resultUser);

            if (value == 2)
            {
                lblTimer.Text = "TimeOut!";
                //lblTimerXText.Text = "Aspetta! Il master sta scegliendo il vincitore.";
                lblTimerXText.Text = "Wait! The master is choosing the winner.";
                btnConfirmCardSelect.Enabled = false;
                NewCardWhite();
                int r = 0;
                FunctionsDB.UpdateNewRound(indexRoom, r);
                Timer4.Dispose();
                Timer4.Enabled = false;
                Timer5.Enabled = true;
                lblTimer.Visible = false;       
            }
            else
            {
                if (value == 0)
                {
                    //string script = "alert(\"Devi selezionare 2 carte prima di cliccare su conferma!\");";
                    string script = "alert(\"You must select 2 cards before clicking to confirm!\");";
                    //ScriptManager.RegisterStartupScript(this, GetType(), "", script, true);
                    ScriptManager.RegisterClientScriptBlock((sender as Control), this.GetType(), "alert", script, true);
                    btnConfirmCardSelect.Enabled = true;
                }
                if (value > 2)
                {
                    //string script = "alert(\"Devi selezionare solo 2 carte!\");";
                    string script = "alert(\"You must select 2 cards!\");";
                    //ScriptManager.RegisterStartupScript(this, GetType(), "", script, true);
                    ScriptManager.RegisterClientScriptBlock((sender as Control), this.GetType(), "alert", script, true);
                    btnConfirmCardSelect.Enabled = true;
                    FunctionsDB.DeleteCardSelectUser(indexRoom, Master.resultUser);
                }
                if (value == 1)
                {
                    //string script = "alert(\"Devi selezionare ancora 1 carta!\");";
                    string script = "alert(\"You must still select 1 card!\");";
                    //ScriptManager.RegisterStartupScript(this, GetType(), "", script, true);
                    ScriptManager.RegisterClientScriptBlock((sender as Control), this.GetType(), "alert", script, true);
                    btnConfirmCardSelect.Enabled = true;
                }
            }
        }

        if (spacesBlackCard == 3)
        {
            int value = FunctionsDB.ReadNCardSelect(indexRoom, Master.resultUser);
            
            if (value == 3)
            {
                lblTimer.Text = "TimeOut!";
                //lblTimerXText.Text = "Aspetta! Il master sta scegliendo il vincitore.";
                lblTimerXText.Text = "Wait! The master is choosing the winner.";
                btnConfirmCardSelect.Enabled = false;
                NewCardWhite();
                int r = 0;
                FunctionsDB.UpdateNewRound(indexRoom, r);
                Timer4.Dispose();
                Timer4.Enabled = false;
                Timer5.Enabled = true;
                lblTimer.Visible = false;       
            }
            else
            {
                if (value == 0)
                {
                    //string script = "alert(\"Devi selezionare 3 carte prima di cliccare su conferma!\");";
                    string script = "alert(\"You must select 3 cards before clicking to confirm!\");";
                    //ScriptManager.RegisterStartupScript(this, GetType(), "", script, true);
                    ScriptManager.RegisterClientScriptBlock((sender as Control), this.GetType(), "alert", script, true);
                    btnConfirmCardSelect.Enabled = true;
                }
                if (value > 3)
                {
                    //string script = "alert(\"Devi selezionare solo 3 carte!\");";
                    string script = "alert(\"You must select only 3 cards!\");";
                    //ScriptManager.RegisterStartupScript(this, GetType(), "", script, true);
                    ScriptManager.RegisterClientScriptBlock((sender as Control), this.GetType(), "alert", script, true);
                    btnConfirmCardSelect.Enabled = true;
                    FunctionsDB.DeleteCardSelectUser(indexRoom, Master.resultUser);
                }
                if (value == 1)
                {
                    //string script = "alert(\"Devi selezionare ancora 2 carte!\");";
                    string script = "alert(\"You must select 2 cards yet!\");";
                    //ScriptManager.RegisterStartupScript(this, GetType(), "", script, true);
                    ScriptManager.RegisterClientScriptBlock((sender as Control), this.GetType(), "alert", script, true);
                    btnConfirmCardSelect.Enabled = true;
                }
                if (value == 2)
                {
                    //string script = "alert(\"Devi selezionare ancora 1 carta!\");";
                    string script = "alert(\"You must still select 1 card!\");";
                    //ScriptManager.RegisterStartupScript(this, GetType(), "", script, true);
                    ScriptManager.RegisterClientScriptBlock((sender as Control), this.GetType(), "alert", script, true);
                    btnConfirmCardSelect.Enabled = true;
                }             
            }
        } 
    }
    
    protected void btnConfirmWinner_Click(object sender, EventArgs e)
    {
        Cards CardSelect = new Cards();

        int spacesBlackCard = room.CheckStringBlackCard(indexRoom);
        int user = FunctionsDB.UsersNotMaster(indexRoom);
        //if (user == 4)
        //{
        //    if (spacesBlackCard == 1)
        //    {
        //        if (btnWhite1.BackColor == System.Drawing.Color.LightBlue)
        //        {
        //            Cards c = new Cards();
        //            c.Text = btnWhite1.Text;
        //            c.idCards = Convert.ToInt32(btnWhite1.Attributes["value"]);
        //            CardSelect = c;
        //        }
        //        if (btnWhite2.BackColor == System.Drawing.Color.LightBlue)
        //        {
        //            Cards c = new Cards();
        //            c.Text = btnWhite2.Text;
        //            c.idCards = Convert.ToInt32(btnWhite2.Attributes["value"]);
        //            CardSelect = c;
        //        }
        //        if (btnWhite3.BackColor == System.Drawing.Color.LightBlue)
        //        {
        //            Cards c = new Cards();
        //            c.Text = btnWhite3.Text;
        //            c.idCards = Convert.ToInt32(btnWhite3.Attributes["value"]);
        //            CardSelect = c;
        //        }
        //        if (btnWhite4.BackColor == System.Drawing.Color.LightBlue)
        //        {
        //            Cards c = new Cards();
        //            c.Text = btnWhite4.Text;
        //            c.idCards = Convert.ToInt32(btnWhite4.Attributes["value"]);
        //            CardSelect = c;
        //        }

        //        lblUser1.Visible = true;
        //        lblUser2.Visible = true;
        //        lblUser3.Visible = true;
        //        lblUser4.Visible = true;
        //    }

        //    if (spacesBlackCard == 2)
        //    {
        //        if (btnWhite1.BackColor == System.Drawing.Color.LightBlue)
        //        {
        //            Cards c = new Cards();
        //            c.Text = btnWhite1.Text;
        //            c.idCards = Convert.ToInt32(btnWhite1.Attributes["value"]);
        //            CardSelect = c;
        //        }

        //        if (btnWhite3.BackColor == System.Drawing.Color.LightBlue)
        //        {
        //            Cards c = new Cards();
        //            c.Text = btnWhite3.Text;
        //            c.idCards = Convert.ToInt32(btnWhite3.Attributes["value"]);
        //            CardSelect = c;
        //        }

        //        if (btnWhite5.BackColor == System.Drawing.Color.LightBlue)
        //        {
        //            Cards c = new Cards();
        //            c.Text = btnWhite5.Text;
        //            c.idCards = Convert.ToInt32(btnWhite5.Attributes["value"]);
        //            CardSelect = c;
        //        }

        //        if (btnWhite7.BackColor == System.Drawing.Color.LightBlue)
        //        {
        //            Cards c = new Cards();
        //            c.Text = btnWhite7.Text;
        //            c.idCards = Convert.ToInt32(btnWhite7.Attributes["value"]);
        //            CardSelect = c;
        //        }
        //        lblUser1.Visible = true;
        //        lblUser2.Visible = true;
        //        lblUser3.Visible = true;
        //        lblUser4.Visible = true;
        //        lblUser5.Visible = true;
        //        lblUser6.Visible = true;
        //        lblUser7.Visible = true;
        //        lblUser8.Visible = true;
        //    }

        //    if (spacesBlackCard == 3)
        //    {
        //        if (btnWhite1.BackColor == System.Drawing.Color.LightBlue)
        //        {
        //            Cards c = new Cards();
        //            c.Text = btnWhite1.Text;
        //            c.idCards = Convert.ToInt32(btnWhite1.Attributes["value"]);
        //            CardSelect = c;
        //        }

        //        if (btnWhite4.BackColor == System.Drawing.Color.LightBlue)
        //        {
        //            Cards c = new Cards();
        //            c.Text = btnWhite4.Text;
        //            c.idCards = Convert.ToInt32(btnWhite4.Attributes["value"]);
        //            CardSelect = c;
        //        }

        //        if (btnWhite7.BackColor == System.Drawing.Color.LightBlue)
        //        {
        //            Cards c = new Cards();
        //            c.Text = btnWhite7.Text;
        //            c.idCards = Convert.ToInt32(btnWhite7.Attributes["value"]);
        //            CardSelect = c;
        //        }

        //        if (btnWhite10.BackColor == System.Drawing.Color.LightBlue)
        //        {
        //            Cards c = new Cards();
        //            c.Text = btnWhite10.Text;
        //            c.idCards = Convert.ToInt32(btnWhite10.Attributes["value"]);
        //            CardSelect = c;
        //        }

        //        lblUser1.Visible = true;
        //        lblUser2.Visible = true;
        //        lblUser3.Visible = true;
        //        lblUser4.Visible = true;
        //        lblUser5.Visible = true;
        //        lblUser6.Visible = true;
        //        lblUser7.Visible = true;
        //        lblUser8.Visible = true;
        //        lblUser9.Visible = true;
        //        lblUser10.Visible = true;
        //        lblUser11.Visible = true;
        //        lblUser12.Visible = true;
        //    }
        //}

        if (user == 2)
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
                lblUser1.Visible = true;
                lblUser2.Visible = true;
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
                lblUser1.Visible = true;
                lblUser2.Visible = true;
                lblUser3.Visible = true;
                lblUser4.Visible = true;
                /*lblUser5.Visible = true;
                lblUser6.Visible = true;*/
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
                lblUser1.Visible = true;
                lblUser2.Visible = true;
                lblUser3.Visible = true;
                lblUser4.Visible = true;
                lblUser5.Visible = true;
                lblUser6.Visible = true;
            }
        }
        NameUsers(spacesBlackCard);
        FunctionsDB.WritePoint(indexRoom, CardSelect);
        Account userWin = FunctionsDB.ReadUserWin(indexRoom, CardSelect);
        FunctionsDB.UpadateIsWinner(userWin, 1);
        FunctionsDB.DeleteCardSelectDB(indexRoom);
        btnConfirmWinner.Enabled = false;
        room.NewRaund(indexRoom, Master.resultUser);
        //FunctionsDB.UpdateNewRounds(indexRoom, 1);      
        lblTimerMaster.Text = "TimeOut!";
        Timer2.Dispose();
        Timer2.Enabled = false;  
        Timer3.Enabled = true;      
    }

    protected void NameUsers(int spacesBlackCard)
    {
        List<Account> usernames = FunctionsDB.ReadUsernames(indexRoom);
        int user = FunctionsDB.UsersNotMaster(indexRoom);
        if (spacesBlackCard == 1)
        {
            //if (user == 4)
            //{
            //    lblUser1.Attributes.Add("value", usernames[0].idAccount.ToString());
            //    lblUser1.Text = usernames[0].Username;

            //    lblUser2.Attributes.Add("value", usernames[1].idAccount.ToString());
            //    lblUser2.Text = usernames[1].Username;

            //    lblUser3.Attributes.Add("value", usernames[2].idAccount.ToString());
            //    lblUser3.Text = usernames[2].Username;

            //    /*lblUser4.Attributes.Add("value", usernames[3].idAccount.ToString());
            //    lblUser4.Text = usernames[3].Username;*/
            //}

            if (user == 2)
            {
                lblUser1.Attributes.Add("value", usernames[0].idAccount.ToString());
                lblUser1.Text = usernames[0].Username;

                lblUser2.Attributes.Add("value", usernames[1].idAccount.ToString());
                lblUser2.Text = usernames[1].Username;
            }
        }

        if (spacesBlackCard == 2)
        {
            //if (user == 4)
            //{
            //    lblUser1.Attributes.Add("value", usernames[0].idAccount.ToString());
            //    lblUser1.Text = usernames[0].Username;

            //    lblUser2.Attributes.Add("value", usernames[1].idAccount.ToString());
            //    lblUser2.Text = usernames[1].Username;

            //    lblUser3.Attributes.Add("value", usernames[2].idAccount.ToString());
            //    lblUser3.Text = usernames[2].Username;

            //    lblUser4.Attributes.Add("value", usernames[3].idAccount.ToString());
            //    lblUser4.Text = usernames[3].Username;

            //    lblUser5.Attributes.Add("value", usernames[4].idAccount.ToString());
            //    lblUser5.Text = usernames[4].Username;

            //    lblUser6.Attributes.Add("value", usernames[5].idAccount.ToString());
            //    lblUser6.Text = usernames[5].Username;

            //    /* lblUser7.Attributes.Add("value", usernames[6].idAccount.ToString());
            //    lblUser7.Text = usernames[6].Username;

            //    lblUser8.Attributes.Add("value", usernames[7].idAccount.ToString());
            //    lblUser8.Text = usernames[7].Username;*/
            //}

            if (user == 2)
            {
                lblUser1.Attributes.Add("value", usernames[0].idAccount.ToString());
                lblUser1.Text = usernames[0].Username;

                lblUser2.Attributes.Add("value", usernames[1].idAccount.ToString());
                lblUser2.Text = usernames[1].Username;

                lblUser3.Attributes.Add("value", usernames[2].idAccount.ToString());
                lblUser3.Text = usernames[2].Username;

                lblUser4.Attributes.Add("value", usernames[3].idAccount.ToString());
                lblUser4.Text = usernames[3].Username;
            }
        }

        if (spacesBlackCard == 3)
        {
            //if (user == 4)
            //{
            //    lblUser1.Attributes.Add("value", usernames[0].idAccount.ToString());
            //    lblUser1.Text = usernames[0].Username;

            //    lblUser2.Attributes.Add("value", usernames[1].idAccount.ToString());
            //    lblUser2.Text = usernames[1].Username;

            //    lblUser3.Attributes.Add("value", usernames[2].idAccount.ToString());
            //    lblUser3.Text = usernames[2].Username;

            //    lblUser4.Attributes.Add("value", usernames[3].idAccount.ToString());
            //    lblUser4.Text = usernames[3].Username;

            //    lblUser5.Attributes.Add("value", usernames[4].idAccount.ToString());
            //    lblUser5.Text = usernames[4].Username;

            //    lblUser6.Attributes.Add("value", usernames[5].idAccount.ToString());
            //    lblUser6.Text = usernames[5].Username;

            //    lblUser7.Attributes.Add("value", usernames[6].idAccount.ToString());
            //    lblUser7.Text = usernames[6].Username;

            //    lblUser8.Attributes.Add("value", usernames[7].idAccount.ToString());
            //    lblUser8.Text = usernames[7].Username;

            //    lblUser9.Attributes.Add("value", usernames[8].idAccount.ToString());
            //    lblUser9.Text = usernames[8].Username;

            //    /*lblUser10.Attributes.Add("value", usernames[9].idAccount.ToString());
            //    lblUser10.Text = usernames[9].Username;

            //    lblUser11.Attributes.Add("value", usernames[10].idAccount.ToString());
            //    lblUser11.Text = usernames[10].Username;

            //    lblUser12.Attributes.Add("value", usernames[11].idAccount.ToString());
            //    lblUser12.Text = usernames[1].Username;*/
            //}

            if (user == 2)
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

    protected void CheckbtnCardSelected()
    {
        List<Cards> textCardSelect = FunctionsDB.ReadTetxtCardsSelect(indexRoom);
        int user = FunctionsDB.UsersNotMaster(indexRoom);
        int spacesBlackCard = room.CheckStringBlackCard(indexRoom);

        //if (user == 4)
        //{
        //    if (spacesBlackCard == 1)
        //    {
        //        lblUser1.Visible = true;
        //        lblUser1.Text = "User 1";

        //        lblUser2.Visible = true;
        //        lblUser2.Text = "User 2";

        //        lblUser3.Visible = true;
        //        lblUser3.Text = "User 3";

        //        lblUser4.Visible = true;
        //        lblUser4.Text = "User 4";

        //        btnWhite1.Attributes.Add("value", textCardSelect[0].idCards.ToString());
        //        btnWhite1.Text = textCardSelect[0].Text;

        //        btnWhite2.Attributes.Add("value", textCardSelect[1].idCards.ToString());
        //        btnWhite2.Text = textCardSelect[1].Text;

        //        btnWhite3.Attributes.Add("value", textCardSelect[2].idCards.ToString());
        //        btnWhite3.Text = textCardSelect[2].Text;

        //        /*btnWhite4.Attributes.Add("value", textCardSelect[3].idCards.ToString());
        //        btnWhite4.Text = textCardSelect[3].Text;*/

        //        btnWhite1.Enabled = true;
        //        btnWhite2.Enabled = true;
        //        btnWhite3.Enabled = true;
        //        btnWhite4.Enabled = true;
        //    }

        //    if (spacesBlackCard == 2)
        //    {
        //        lblUser1.Visible = true;
        //        lblUser1.Text = "User 1";

        //        lblUser2.Visible = true;
        //        lblUser2.Text = "User 1";

        //        lblUser3.Visible = true;
        //        lblUser3.Text = "User 2";

        //        lblUser4.Visible = true;
        //        lblUser4.Text = "User 2";

        //        lblUser5.Visible = true;
        //        lblUser5.Text = "User 3";

        //        lblUser6.Visible = true;
        //        lblUser6.Text = "User 3";

        //        lblUser7.Visible = true;
        //        lblUser7.Text = "User 4";

        //        lblUser8.Visible = true;
        //        lblUser8.Text = "User 4";

        //        btnWhite1.Attributes.Add("value", textCardSelect[0].idCards.ToString());
        //        btnWhite1.Text = textCardSelect[0].Text;

        //        btnWhite2.Attributes.Add("value", textCardSelect[1].idCards.ToString());
        //        btnWhite2.Text = textCardSelect[1].Text;

        //        btnWhite3.Attributes.Add("value", textCardSelect[2].idCards.ToString());
        //        btnWhite3.Text = textCardSelect[2].Text;

        //        btnWhite4.Attributes.Add("value", textCardSelect[3].idCards.ToString());
        //        btnWhite4.Text = textCardSelect[3].Text;

        //        btnWhite5.Attributes.Add("value", textCardSelect[4].idCards.ToString());
        //        btnWhite5.Text = textCardSelect[4].Text;

        //        btnWhite6.Attributes.Add("value", textCardSelect[5].idCards.ToString());
        //        btnWhite6.Text = textCardSelect[5].Text;

        //        /*btnWhite7.Attributes.Add("value", textCardSelect[6].idCards.ToString());
        //        btnWhite7.Text = textCardSelect[6].Text;

        //        btnWhite8.Attributes.Add("value", textCardSelect[7].idCards.ToString());
        //        btnWhite8.Text = textCardSelect[7].Text;*/

        //        btnWhite1.Enabled = true;
        //        btnWhite3.Enabled = true;
        //        btnWhite5.Enabled = true;
        //        btnWhite7.Enabled = true;
        //    }

        //    if (spacesBlackCard == 3)
        //    {
        //        lblUser1.Visible = true;
        //        lblUser1.Text = "User 1";

        //        lblUser2.Visible = true;
        //        lblUser2.Text = "User 1";

        //        lblUser3.Visible = true;
        //        lblUser3.Text = "User 1";

        //        lblUser4.Visible = true;
        //        lblUser4.Text = "User 2";

        //        lblUser5.Visible = true;
        //        lblUser5.Text = "User 2";

        //        lblUser6.Visible = true;
        //        lblUser6.Text = "User 2";

        //        lblUser7.Visible = true;
        //        lblUser7.Text = "User 3";

        //        lblUser8.Visible = true;
        //        lblUser8.Text = "User 3";

        //        lblUser9.Visible = true;
        //        lblUser9.Text = "User 3";

        //        lblUser10.Visible = true;
        //        lblUser10.Text = "User 4";

        //        lblUser11.Visible = true;
        //        lblUser11.Text = "User 4";

        //        lblUser12.Visible = true;
        //        lblUser12.Text = "User 4";

        //        btnWhite1.Attributes.Add("value", textCardSelect[0].idCards.ToString());
        //        btnWhite1.Text = textCardSelect[0].Text;

        //        btnWhite2.Attributes.Add("value", textCardSelect[1].idCards.ToString());
        //        btnWhite2.Text = textCardSelect[1].Text;

        //        btnWhite3.Attributes.Add("value", textCardSelect[2].idCards.ToString());
        //        btnWhite3.Text = textCardSelect[2].Text;

        //        btnWhite4.Attributes.Add("value", textCardSelect[3].idCards.ToString());
        //        btnWhite4.Text = textCardSelect[3].Text;

        //        btnWhite5.Attributes.Add("value", textCardSelect[4].idCards.ToString());
        //        btnWhite5.Text = textCardSelect[4].Text;

        //        btnWhite6.Attributes.Add("value", textCardSelect[5].idCards.ToString());
        //        btnWhite6.Text = textCardSelect[5].Text;

        //        btnWhite7.Attributes.Add("value", textCardSelect[6].idCards.ToString());
        //        btnWhite7.Text = textCardSelect[6].Text;

        //        btnWhite8.Attributes.Add("value", textCardSelect[7].idCards.ToString());
        //        btnWhite8.Text = textCardSelect[7].Text;

        //        btnWhite9.Attributes.Add("value", textCardSelect[8].idCards.ToString());
        //        btnWhite9.Text = textCardSelect[8].Text;

        //        /*btnWhite10.Attributes.Add("value", textCardSelect[9].idCards.ToString());
        //        btnWhite10.Text = textCardSelect[9].Text;

        //        btnWhite11.Attributes.Add("value", textCardSelect[10].idCards.ToString());
        //        btnWhite11.Text = textCardSelect[10].Text;

        //        btnWhite12.Attributes.Add("value", textCardSelect[11].idCards.ToString());
        //        btnWhite12.Text = textCardSelect[11].Text;*/

        //        btnWhite1.Enabled = true;
        //        btnWhite4.Enabled = true;
        //        btnWhite7.Enabled = true;
        //        btnWhite10.Enabled = true;
        //    }
        //}

        if (user == 2)
        {
            if (spacesBlackCard == 1)
            {
                lblUser1.Visible = true;
                lblUser1.Text = "User 1";

                lblUser2.Visible = true;
                lblUser2.Text = "User 2";

                btnWhite1.Attributes.Add("value", textCardSelect[0].idCards.ToString());
                btnWhite1.Text = textCardSelect[0].Text;

                btnWhite2.Attributes.Add("value", textCardSelect[1].idCards.ToString());
                btnWhite2.Text = textCardSelect[1].Text;

                btnWhite1.Enabled = true;
                btnWhite2.Enabled = true;
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
                
                btnWhite1.Attributes.Add("value", textCardSelect[0].idCards.ToString());
                btnWhite1.Text = textCardSelect[0].Text;

                btnWhite2.Attributes.Add("value", textCardSelect[1].idCards.ToString());
                btnWhite2.Text = textCardSelect[1].Text;

                btnWhite3.Attributes.Add("value", textCardSelect[2].idCards.ToString());
                btnWhite3.Text = textCardSelect[2].Text;

                btnWhite4.Attributes.Add("value", textCardSelect[3].idCards.ToString());
                btnWhite4.Text = textCardSelect[3].Text;

                btnWhite1.Enabled = true;
                btnWhite3.Enabled = true;
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

                btnWhite1.Enabled = true;
                btnWhite4.Enabled = true;
            }
        }
    }
    
    //Timer utilizzato nella pagina del master per aspettare che i giocatori scelgano le carte
    protected void Timer1_Tick(object sender, EventArgs e)
    {
        //TimeSpan time1 = new TimeSpan();
        //time1 = (DateTime)Session["time1"] - DateTime.Now;
        //if (time1.Seconds <= 0)
        //{
        Session["time1"] = Convert.ToInt16(Session["time1"]) - 1;
        if (Convert.ToInt16(Session["time1"]) <= 0)
        {
            lblTimerMaster.Visible = true;
            btnConfirmWinner.Visible = true;
            if (room.CheckUserCardSelected(indexRoom))
            {
                CheckbtnCardSelected();
                //lblTimerXText.Text = "Timer per la scelta del vincitore: ";
                lblTimerXText.Text = "Timer for choosing the winner: ";
                Timer1.Dispose();
                Timer1.Enabled = false;
                Timer2.Enabled = true;
            }
            else
            {
                FunctionsDB.UpdateUserExit(Master.resultUser);
                //int userExit = FunctionsDB.ReadUserExit();
                //if (userExit > 0)
                //{
                    UpdateMatches();
                    Response.Redirect("~/index.aspx");
                //}
            }
        }
        else
        {
            //Label4.Text = time1.Minutes.ToString() + ":" + time1.Seconds.ToString();
            totalSeconds = Convert.ToInt16(Session["time1"]);
            seconds = totalSeconds % 60;
            minutes = totalSeconds / 60;
            time = minutes + ":" + seconds;
            Label4.Text = time;
            int userExit = FunctionsDB.ReadUserExit();
            if (userExit > 0)
            {
                UpdateMatches();
                Response.Redirect("~/index.aspx");
            }
            if (room.CheckUserCardSelected(indexRoom))
            {
                CheckbtnCardSelected();
                lblTimerMaster.Visible = true;
                btnConfirmWinner.Visible = true;
                //lblTimerXText.Text = "Timer per la scelta del vincitore: ";
                lblTimerXText.Text = "Timer for choosing the winner: ";
                Timer1.Dispose();
                Timer2.Enabled = true;
                Timer1.Enabled = false;
            }
        }
    }
    protected void Timer2_Tick(object sender, EventArgs e)
    {
        //TimeSpan time2 = new TimeSpan();
        //time2 = (DateTime)Session["time2"] - DateTime.Now;
        //if (time2.Seconds <= 0)
        //{
        lblTimerMaster.Visible = true;
        Session["time2"] = Convert.ToInt16(Session["time2"]) - 1;
        if (Convert.ToInt16(Session["time2"]) <= 0)
        {
            lblTimerMaster.Text = "TimeOut!";

            if (btnConfirmWinner.Enabled == true)
            {
                int BlackCardSpaces = room.CheckStringBlackCard(indexRoom);

                List<Cards> listCards = FunctionsDB.ReadTetxtCardsSelect(indexRoom);

                if (BlackCardSpaces == 1)
                {
                    int cardCount = RandomCard(listCards);
                    Cards cardSelect = new Cards();
                    cardSelect = listCards[cardCount];
                    NameUsers(BlackCardSpaces);
                    FunctionsDB.WritePoint(indexRoom, cardSelect);
                    FunctionsDB.DeleteCardSelectDB(indexRoom);
                    btnConfirmWinner.Enabled = false;
                    room.NewRaund(indexRoom, Master.resultUser);
                    Timer2.Dispose();
                    Timer2.Enabled = false;
                    Timer3.Enabled = true;                    
                }

                if (BlackCardSpaces == 2)
                {
                    int cardCount = RandomCard(listCards);
                    Cards cardSelect = new Cards();
                    cardSelect = listCards[cardCount];
                    NameUsers(BlackCardSpaces);
                    FunctionsDB.WritePoint(indexRoom, cardSelect);
                    FunctionsDB.DeleteCardSelectDB(indexRoom);
                    btnConfirmWinner.Enabled = false;
                    room.NewRaund(indexRoom, Master.resultUser);
                    Timer2.Dispose();
                    Timer2.Enabled = false;
                    Timer3.Enabled = true;       
                }

                if (BlackCardSpaces == 3)
                {
                    int cardCount = RandomCard(listCards);
                    Cards cardSelect = new Cards();
                    cardSelect = listCards[cardCount];
                    NameUsers(BlackCardSpaces);
                    FunctionsDB.WritePoint(indexRoom, cardSelect);
                    FunctionsDB.DeleteCardSelectDB(indexRoom);
                    btnConfirmWinner.Enabled = false;
                    room.NewRaund(indexRoom, Master.resultUser);
                    Timer2.Dispose();
                    Timer2.Enabled = false;
                    Timer3.Enabled = true;       
                }
            }
            else
            {
                Timer2.Dispose();
                Timer2.Enabled = false;
                Timer3.Enabled = true;       
            }
        }
        else
        {
            //lblTimerMaster.Text = time2.Minutes.ToString() + ":" + time2.Seconds.ToString();
            totalSeconds = Convert.ToInt16(Session["time2"]);
            seconds = totalSeconds % 60;
            minutes = totalSeconds / 60;
            time = minutes + ":" + seconds;
            lblTimerMaster.Text = time;
            int userExit = FunctionsDB.ReadUserExit();
            if (userExit > 0)
            {
                UpdateMatches();
                Response.Redirect("~/index.aspx");
            }
        }
    }

    protected void Timer3_Tick(object sender, EventArgs e)
    {
        //TimeSpan time3 = new TimeSpan();
        //time3 = (DateTime)Session["time3"] - DateTime.Now;
        //int time = FunctionsDB.ReadTimer(indexRoom);
        //if (time == 3)
        //{
        //    Timer3.Dispose();
        //    Timer3.Enabled = false;
        //    FunctionsDB.ResetTimer(indexRoom);
        //    Response.Redirect("~/game.aspx");
        //}
        //if (time3.Seconds <= 0)
        //{
        Session["time3"] = Convert.ToInt16(Session["time3"]) - 1;
        if (Convert.ToInt16(Session["time3"]) <= 0)
        {
            Timer3.Dispose();
            Timer3.Enabled = false;
            //FunctionsDB.ResetTimer(indexRoom);
            Response.Redirect("~/game.aspx");
        }
        else
        {
            //Label3.Text = time3.Minutes.ToString() + ":" + time3.Seconds.ToString();
            //FunctionsDB.UpdateTimer(indexRoom);
            totalSeconds = Convert.ToInt16(Session["time3"]);
            seconds = totalSeconds % 60;
            minutes = totalSeconds / 60;
            time = minutes + ":" + seconds;
            Label3.Text = time;
            int userExit = FunctionsDB.ReadUserExit();
            if (userExit > 0)
            {
                UpdateMatches();
                Response.Redirect("~/index.aspx");
            }
        }
    }

    protected void Timer4_Tick(object sender, EventArgs e)
    {
        //TimeSpan time4 = new TimeSpan();
        //time4 = (DateTime)Session["time4"] - DateTime.Now;
        //if (time4.Seconds <= 0)
        //{
        Session["time4"] = Convert.ToInt16(Session["time4"]) - 1;
        if (Convert.ToInt16(Session["time4"]) <= 0)
        {
            lblTimer.Text = "TimeOut!";
            //lblTimerXText.Text = "Aspetta! Il master sta scegliendo il vincitore";
            lblTimerXText.Text = "Wait! The master is choosing the winner.";
            if (btnConfirmCardSelect.Enabled == true)
            {
                int spacesBlackCard = room.CheckStringBlackCard(indexRoom);
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
                    int r = 0;
                    FunctionsDB.UpdateNewRound(indexRoom, r);
                    Timer4.Dispose();
                    Timer4.Enabled = false;
                    Timer5.Enabled = true;
                    lblTimer.Visible = false;
                }

                if (spacesBlackCard == 2)
                {
                    int value = FunctionsDB.ReadNCardSelect(indexRoom, Master.resultUser);

                    if (value == 1)
                    {
                        int cardCount = RandomCard(listCards);
                        List<Cards> cardSelect = new List<Cards>();
                        cardSelect.Add(listCards[cardCount]);
                        room.DeleteCardForUser(Master.resultUser, listCards[cardCount].idCards);
                        room.UsersAndCards(cardSelect, indexRoom, Master.resultUser);
                        room.GenerateCardForUser(Master.resultUser);
                        btnConfirmCardSelect.Enabled = false;
                        int r = 0;
                        FunctionsDB.UpdateNewRound(indexRoom, r);
                        Timer4.Dispose();
                        Timer4.Enabled = false;
                        Timer5.Enabled = true;
                        lblTimer.Visible = false;
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
                        int r = 0;
                        FunctionsDB.UpdateNewRound(indexRoom, r);
                        Timer4.Dispose();
                        Timer4.Enabled = false;
                        Timer5.Enabled = true;
                        lblTimer.Visible = false;
                    }
                }

                if (spacesBlackCard == 3)
                {
                    int value = FunctionsDB.ReadNCardSelect(indexRoom, Master.resultUser);
                    if (value == 1)
                    {
                        int cardCount = RandomCard(listCards);
                        List<Cards> cardSelect = new List<Cards>();
                        cardSelect.Add(listCards[cardCount]);
                        room.DeleteCardForUser(Master.resultUser, listCards[cardCount].idCards);
                        room.UsersAndCards(cardSelect, indexRoom, Master.resultUser);
                        room.GenerateCardForUser(Master.resultUser);
                        btnConfirmCardSelect.Enabled = false;
                        int r = 0;
                        FunctionsDB.UpdateNewRound(indexRoom, r);
                        Timer4.Dispose();
                        Timer4.Enabled = false;
                        Timer5.Enabled = true;
                        lblTimer.Visible = false;
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
                        int r = 0;
                        FunctionsDB.UpdateNewRound(indexRoom, r);
                        Timer4.Dispose();
                        Timer4.Enabled = false;
                        Timer5.Enabled = true;
                        lblTimer.Visible = false;
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
                        int r = 0;
                        FunctionsDB.UpdateNewRound(indexRoom, r);
                        Timer4.Dispose();
                        Timer4.Enabled = false;
                        Timer5.Enabled = true;
                        lblTimer.Visible = false;
                    }
                }
            }
            else
            {
                int r = 0;
                FunctionsDB.UpdateNewRound(indexRoom, r);
                lblTimer.Visible = false;
                Timer4.Dispose();
                Timer4.Enabled = false;
                Timer5.Enabled = true;
            }
        }
        else
        {
            //lblTimer.Text = time4.Minutes.ToString() + ":" + time4.Seconds.ToString();
            totalSeconds = Convert.ToInt16(Session["time4"]);
            seconds = totalSeconds % 60;
            minutes = totalSeconds / 60;
            time = minutes + ":" + seconds;
            lblTimer.Text = time;
            int userExit = FunctionsDB.ReadUserExit();
            if (userExit > 0)
            {
                UpdateMatches();
                Response.Redirect("~/index.aspx");
            }
        }
    }

    protected void Timer5_Tick(object sender, EventArgs e)
    {
        //TimeSpan time5 = new TimeSpan();
        //time5 = (DateTime)Session["time5"] - DateTime.Now;
        //if (time5.Seconds <= 0)
        //{
        Session["time5"] = Convert.ToInt16(Session["time5"]) - 1;
        if (Convert.ToInt16(Session["time5"]) <= 0)
        {
            Timer5.Dispose();
            Timer5.Enabled = false;
            Response.Redirect("~/game.aspx");
        }
        else
        {
            //Label2.Text = time5.Minutes.ToString() + ":" + time5.Seconds.ToString();
            totalSeconds = Convert.ToInt16(Session["time5"]);
            seconds = totalSeconds % 60;
            minutes = totalSeconds / 60;
            time = minutes + ":" + seconds;
            Label2.Text = time;
            Round round = FunctionsDB.ReadRounds(indexRoom);
            int userExit = FunctionsDB.ReadUserExit();
            if (userExit > 0)
            {
                UpdateMatches();
                Response.Redirect("~/index.aspx");
            }
            if (round.newRound == 1)
            {
                String usernameWinner = FunctionsDB.ReadUsernameWinner();
                string script = "alert(\"The winner of round is: " + usernameWinner + "\");";
                ScriptManager.RegisterClientScriptBlock((sender as Control), this.GetType(), "alert", script, true);
                Timer5.Dispose();
                Timer5.Enabled = false;
                Timer6.Enabled = true;
                //Response.Redirect("~/game.aspx");
            }
        }
    }

    protected void Timer6_Tick(object sender, EventArgs e)
    {
        Session["time6"] = Convert.ToInt16(Session["time6"]) - 1;
        if (Convert.ToInt16(Session["time6"]) <= 0)
        {
            if (FunctionsDB.CheckUserIsWinner(Master.resultUser))
            {
                FunctionsDB.UpadateIsWinner(Master.resultUser, 0);
                Response.Redirect("~/game.aspx");
            }
            else
            {
                Response.Redirect("~/game.aspx");
            }
        }
        else
        {
            //Label2.Text = time5.Minutes.ToString() + ":" + time5.Seconds.ToString();
            totalSeconds = Convert.ToInt16(Session["time6"]);
            seconds = totalSeconds % 60;
            minutes = totalSeconds / 60;
            time = minutes + ":" + seconds;
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
        </div>
        <asp:UpdatePanel ID="Pannello" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:Timer ID="Timer1" runat="server" Enabled="False" Interval="1000" OnTick="Timer1_Tick" />
                <asp:Timer ID="Timer2" runat="server" Enabled="False" Interval="1000" OnTick="Timer2_Tick" />
                <asp:Timer ID="Timer3" runat="server" Enabled="False" Interval="1000" OnTick="Timer3_Tick" />
                <asp:Timer ID="Timer4" runat="server" Enabled="False" Interval="1000" OnTick="Timer4_Tick"></asp:Timer>
                <asp:Timer ID="Timer5" runat="server" Interval="1000" Enabled="False" EnableViewState="True" OnTick="Timer5_Tick"></asp:Timer>
                <asp:Timer ID="Timer6" runat="server" Interval="1000" Enabled="False" EnableViewState="True" OnTick="Timer6_Tick" ></asp:Timer>
                <asp:Label ID="lblTimerXText" runat="server" ForeColor="Black" Font-Bold="True"></asp:Label>
                <asp:Label ID="lblTimer" runat="server" ForeColor="#CC0000" Font-Bold="True"></asp:Label>
                <asp:Label ID="lblTimerMaster" runat="server" ForeColor="#CC0000" Font-Bold="True"></asp:Label>
                <br />
                <asp:Label ID="Label1" runat="server" Visible="false"></asp:Label>
                <asp:Label ID="Label2" runat="server" Visible="false"></asp:Label>
                <asp:Label ID="Label3" runat="server" Visible="false"></asp:Label>
                <asp:Label ID="Label4" runat="server" Visible="false"></asp:Label>
                <br />
                <div>
                    <asp:Label ID="lblPoints" runat="server" ForeColor="Black" Font-Bold="True"></asp:Label>
                </div>
                <div>
                    <asp:Label ID="lblRounds" runat="server" ForeColor="Black" Font-Bold="True"></asp:Label>
                </div>
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
                                    <asp:Label ID="lblUser1" runat="server" Text="Label" Visible="False"></asp:Label>
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite2" CssClass="card-container white-card text-white" runat="server" Text="" OnClick="btnWhite2_Click" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser2" runat="server" Text="Label" Visible="False"></asp:Label>
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite3" CssClass="card-container white-card text-white" runat="server" Text="" OnClick="btnWhite3_Click" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser3" runat="server" Text="Label" Visible="False"></asp:Label>
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite4" CssClass="card-container white-card text-white" runat="server" Text="" OnClick="btnWhite4_Click" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser4" runat="server" Text="Label" Visible="False"></asp:Label>
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite5" CssClass="card-container white-card text-white" runat="server" Text="" OnClick="btnWhite5_Click" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser5" runat="server" Text="Label" Visible="False"></asp:Label>
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite6" CssClass="card-container white-card text-white" runat="server" Text="" OnClick="btnWhite6_Click" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser6" runat="server" Text="Label" Visible="False"></asp:Label>
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite7" CssClass="card-container white-card text-white" runat="server" Text="" OnClick="btnWhite7_Click" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser7" runat="server" Text="Label" Visible="False"></asp:Label>
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite8" CssClass="card-container white-card text-white" runat="server" Text="" OnClick="btnWhite8_Click" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser8" runat="server" Text="Label" Visible="False"></asp:Label>
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite9" CssClass="card-container white-card text-white" runat="server" Text="" OnClick="btnWhite9_Click" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser9" runat="server" Text="Label" Visible="False"></asp:Label>
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite10" CssClass="card-container white-card text-white" runat="server" Text="" OnClick="btnWhite10_Click" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser10" runat="server" Text="Label" Visible="False"></asp:Label>
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite11" CssClass="card-container white-card text-white" runat="server" Text="" Visible="False" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser11" runat="server" Text="Label" Visible="False"></asp:Label>
                                </div>
                            </div>
                            <div class="col-card-fixed">
                                <asp:Button ID="btnWhite12" CssClass="card-container white-card text-white" runat="server" Text="" Visible="False" />
                                <div class="username-card">
                                    <asp:Label ID="lblUser12" runat="server" Text="Label" Visible="False"></asp:Label>
                                </div>
                            </div>
                            <asp:Button ID="btnConfirmCardSelect" runat="server" Text="Confirm" OnClick="btnConfirmCardSelect_Click" CssClass="btn btn-confirm" />
                            <asp:Button ID="btnConfirmWinner" runat="server" Text="Confirm" OnClick="btnConfirmWinner_Click" CssClass="btn btn-confirm" />
                        </div>
                    </div>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="Timer1" EventName="Tick" />
                <asp:AsyncPostBackTrigger ControlID="Timer2" EventName="Tick" />
                <asp:AsyncPostBackTrigger ControlID="Timer3" EventName="Tick" />
                <asp:AsyncPostBackTrigger ControlID="Timer4" EventName="Tick" />
                <asp:AsyncPostBackTrigger ControlID="Timer5" EventName="Tick" />
            </Triggers>
        </asp:UpdatePanel>
    </div>
</asp:Content>
