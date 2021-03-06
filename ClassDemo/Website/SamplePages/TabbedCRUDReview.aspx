﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="TabbedCRUDReview.aspx.cs" Inherits="SamplePages_TabbedCRUDReview" %>

<%@ Register Src="~/UserControls/MessageUserControl.ascx" TagPrefix="uc1" TagName="MessageUserControl" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
      <div class="row jumbotron">
        <h1>Tabbed CRUD Review</h1>
    </div>
    <uc1:MessageUserControl runat="server" ID="MessageUserControl" />
     <div class="row">
        <div class="col-md-12">
            <!-- Nav tabs -->
            <ul class="nav nav-tabs">
                <li><a href="#search" data-toggle="tab">Lookup</a></li>
                <li><a href="#crud" data-toggle="tab">Add Update Delete</a></li>
                <li class="active"><a href="#listviewcrud" data-toggle="tab">ListView Crud</a></li>
            </ul>
            <!-- tab content area -->
            <div class="tab-content">
                <!-- user tab -->
                <div class="tab-pane fade" id="search">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                           Enter Album Name:
                            <asp:TextBox ID="SearchArgAlbum" runat="server"></asp:TextBox>
                            <asp:Button ID="Fetch" runat="server" Text="Fetch" /><br />
                            <asp:GridView ID="SearchResults" runat="server" 
                                AutoGenerateColumns="False" DataSourceID="SearchResultsODS" 
                                AllowPaging="True" GridLines="None" 
                                OnSelectedIndexChanged="SearchResults_SelectedIndexChanged" OnPageIndexChanging="SearchResults_PageIndexChanging" >
                                <Columns>
                                    <asp:TemplateField >
                                        <ItemTemplate>
                                            <asp:Label runat="server" Text='<%# Bind("AlbumId") %>' 
                                                ID="AlbumID" Visible="false"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="Title" HeaderText="Title" SortExpression="Title"></asp:BoundField>
                                    <asp:TemplateField >
                                        <ItemTemplate>
                                            <asp:DropDownList runat="server"
                                                ID="ArtistList" 
                                                DataSourceID="ArtistListODS" 
                                                DataTextField="Name" 
                                                DataValueField="ArtistId"
                                                SelectedValue='<%# Bind("ArtistID") %>'>
                                            </asp:DropDownList>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ReleaseYear" HeaderText="ReleaseYear" SortExpression="ReleaseYear"></asp:BoundField>
                                    <asp:BoundField DataField="ReleaseLabel" HeaderText="ReleaseLabel" SortExpression="ReleaseLabel"></asp:BoundField>
                                    <asp:CommandField SelectText="View" ShowSelectButton="True"></asp:CommandField>

                                </Columns>
                                <SelectedRowStyle BackColor="#99CCFF" />
                            </asp:GridView>
                            <asp:ObjectDataSource ID="SearchResultsODS" runat="server" 
                                OldValuesParameterFormatString="original_{0}" 
                                SelectMethod="Albums_ListByTitle" 
                                TypeName="ChinookSystem.BLL.AlbumController">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="SearchArgAlbum" 
                                        PropertyName="Text" DefaultValue="zxzx" Name="title" 
                                        Type="String"></asp:ControlParameter>
                                </SelectParameters>
                            </asp:ObjectDataSource>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                
                </div> <%--eop--%>
                <!-- role tab -->
                <div class="tab-pane fade" id="crud">
                    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                        <ContentTemplate>
                            <asp:Label ID="Message" runat="server" ></asp:Label>
                           <table>
                               <tr>
                                   <td>Album ID:</td>
                                   <td>
                                       <asp:Label ID="AlbumID" runat="server" ></asp:Label>
                                   </td>
                               </tr>
                               <tr>
                                   <td>Title:</td>
                                   <td>
                                       <asp:TextBox ID="AlbumTitle" runat="server" ></asp:TextBox>
                                   </td>
                               </tr>
                               <tr>
                                   <td>Artist:</td>
                                   <td>
                                       <asp:DropDownList ID="ArtistList" runat="server" 
                                           DataSourceID="ArtistListODS" 
                                           DataTextField="Name" 
                                           DataValueField="ArtistId"></asp:DropDownList>
                                   </td>
                               </tr>
                               <tr>
                                   <td>Release Year:</td>
                                   <td>
                                       <asp:TextBox ID="ReleaseYear" runat="server" ></asp:TextBox>
                                   </td>
                               </tr>
                               <tr>
                                   <td>Release Label:</td>
                                   <td>
                                       <asp:TextBox ID="ReleaseLabel" runat="server" ></asp:TextBox>
                                   </td>
                               </tr>
                               <tr>
                                   <td colspan="2">
                                   <asp:Button ID="Add" runat="server" Text="Add" Width="100px" OnClick="Add_Click" />&nbsp;&nbsp;
                                   <asp:Button ID="Update" runat="server" Text="Update" Width="100px" OnClick="Update_Click"/>&nbsp;&nbsp;
                                   <asp:Button ID="Delete" runat="server" Text="Delete" Width="100px" OnClick="Delete_Click"/>&nbsp;&nbsp;
                                   <asp:Button ID="Clear" runat="server" Text="Clear" Width="100px" OnClick="Clear_Click"/>
                                   </td>
                               </tr>
                           </table>
                            <asp:ObjectDataSource ID="ArtistListODS" runat="server" 
                                OldValuesParameterFormatString="original_{0}" 
                                SelectMethod="Artist_List" 
                                TypeName="ChinookSystem.BLL.ArtistController"></asp:ObjectDataSource>
                        </ContentTemplate>
                    </asp:UpdatePanel>

                </div> <%--eop--%>
                <!-- unregistered user tab -->
                <div class="tab-pane fade in active" id="listviewcrud">
                    <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                        <ContentTemplate>
                            <asp:ListView ID="ListViewCRUD" runat="server" DataSourceID="ListViewODS" InsertItemPosition="LastItem" DataKeyNames="AlbumID">
                                <AlternatingItemTemplate>
                                    <tr style="background-color: #FFF8DC;">
                                        <td>
                                            <asp:Button runat="server" CommandName="Delete" Text="Delete" ID="DeleteButton" Width="60px"/>
                                            <asp:Button runat="server" CommandName="Edit" Text="Edit" ID="EditButton" Width="50px"/>
                                        </td>
                                        <td>
                                            <asp:Label Text='<%# Eval("AlbumId") %>' runat="server" ID="AlbumIdLabel" Width="50px"/></td>
                                        <td>
                                            <asp:Label Text='<%# Eval("Title") %>' runat="server" ID="TitleLabel" /></td>
                                        <td>
                                            <%-- RADIO BUTTON LIST EXAMPLE: --%> 
<%--                                        <asp:RadioButtonList ID="RadioButtonList1" runat="server" SelectedValue="'<%# Eval("Gender") %>">
                                                <asp:ListItem Value="M">Male</asp:ListItem>
                                                <asp:ListItem Value="F">Female</asp:ListItem>
                                            </asp:RadioButtonList>--%>
                                            <asp:DropDownList ID="ArtistIdDropDownList" runat="server" DataSourceID="ArtistListODS" DataTextField="Name" 
                                            DataValueField="ArtistId" SelectedValue='<%# Eval("ArtistId")%>'></asp:DropDownList>
                                        </td>
                                        <td align="center">
                                            <asp:Label Text='<%# Eval("ReleaseYear") %>' runat="server" ID="ReleaseYearLabel" /></td>
                                        <td>
                                            <asp:Label Text='<%# Eval("ReleaseLabel") %>' runat="server" ID="ReleaseLabelLabel" /></td>
                                    </tr>
                                </AlternatingItemTemplate>
                                <EditItemTemplate>
                                    <tr style="background-color: #008A8C; color: #FFFFFF;">
                                        <td>
                                            <asp:Button runat="server" CommandName="Update" Text="Update" ID="UpdateButton" />
                                            <asp:Button runat="server" CommandName="Cancel" Text="Cancel" ID="CancelButton" />
                                        </td>
                                        <td>
                                            <asp:TextBox Text='<%# Bind("AlbumId") %>' runat="server" ID="AlbumIdTextBox" Enabled="false" Width="50px"/></td>
                                        <td>
                                            <asp:TextBox Text='<%# Bind("Title") %>' runat="server" ID="TitleTextBox" /></td>
                                        <td>
                                            <asp:DropDownList ID="ArtistIdDropDownList" runat="server" DataSourceID="ArtistListODS" DataTextField="Name" 
                                            DataValueField="ArtistId" SelectedValue='<%# Bind("ArtistId")%>'></asp:DropDownList></td>
                                        <td  align="center">
                                            <asp:TextBox Text='<%# Bind("ReleaseYear") %>' runat="server" ID="ReleaseYearTextBox" /></td>
                                        <td>
                                            <asp:TextBox Text='<%# Bind("ReleaseLabel") %>' runat="server" ID="ReleaseLabelTextBox" /></td>
                                    </tr>
                                </EditItemTemplate>
                                <EmptyDataTemplate>
                                    <table runat="server" style="background-color: #FFFFFF; border-collapse: collapse; border-color: #999999; border-style: none; border-width: 1px;">
                                        <tr>
                                            <td>No data was returned.</td>
                                        </tr>
                                    </table>
                                </EmptyDataTemplate>
                                <InsertItemTemplate>
                                    <tr style="">
                                        <td>
                                            <asp:Button runat="server" CommandName="Insert" Text="Insert" ID="InsertButton" />
                                            <asp:Button runat="server" CommandName="Cancel" Text="Clear" ID="CancelButton" />
                                        </td>
                                        <td>
                                            <asp:TextBox Text='<%# Bind("AlbumId") %>' runat="server" ID="AlbumIdTextBox" Width="50px" Enabled="false"/></td>
                                        <td>
                                            <asp:TextBox Text='<%# Bind("Title") %>' runat="server" ID="TitleTextBox" /></td>
                                        <td>
                                            <asp:DropDownList ID="ArtistIdDropDownList" runat="server" DataSourceID="ArtistListODS" DataTextField="Name" 
                                            DataValueField="ArtistId" SelectedValue='<%# Bind("ArtistId")%>'></asp:DropDownList></td>
                                        <td  align="center">
                                            <asp:TextBox Text='<%# Bind("ReleaseYear") %>' runat="server" ID="ReleaseYearTextBox" /></td>
                                        <td>
                                            <asp:TextBox Text='<%# Bind("ReleaseLabel") %>' runat="server" ID="ReleaseLabelTextBox" /></td>
                                    </tr>
                                </InsertItemTemplate>
                                <ItemTemplate>
                                    <tr style="background-color: #DCDCDC; color: #000000;">
                                        <td>
                                            <asp:Button runat="server" CommandName="Delete" Text="Delete" ID="DeleteButton" Width="60px"/>
                                            <asp:Button runat="server" CommandName="Edit" Text="Edit" ID="EditButton" Width="50px"/>
                                        </td>
                                        <td>
                                            <asp:Label Text='<%# Eval("AlbumId") %>' runat="server" ID="AlbumIdLabel" Width="50px"/></td>
                                        <td>
                                            <asp:Label Text='<%# Eval("Title") %>' runat="server" ID="TitleLabel" /></td>
                                        <td>
                                            <asp:DropDownList ID="ArtistIdDropDownList" runat="server" DataSourceID="ArtistListODS" DataTextField="Name" 
                                            DataValueField="ArtistId" SelectedValue='<%# Eval("ArtistId")%>'></asp:DropDownList></td>
                                        <td  align="center">
                                            <asp:Label Text='<%# Eval("ReleaseYear") %>' runat="server" ID="ReleaseYearLabel" /></td>
                                        <td>
                                            <asp:Label Text='<%# Eval("ReleaseLabel") %>' runat="server" ID="ReleaseLabelLabel" /></td>
                                    </tr>
                                </ItemTemplate>
                                <LayoutTemplate>
                                    <table runat="server">
                                        <tr runat="server">
                                            <td runat="server">
                                                <table runat="server" id="itemPlaceholderContainer" style="background-color: #FFFFFF; border-collapse: collapse; border-color: #999999; border-style: none; border-width: 1px; font-family: Verdana, Arial, Helvetica, sans-serif;" border="1">
                                                    <tr runat="server" style="background-color: #DCDCDC; color: #000000;">
                                                        <th runat="server"></th>
                                                        <th runat="server">Id</th>
                                                        <th runat="server">Title</th>
                                                        <th runat="server">ArtistId</th>
                                                        <th runat="server">Rel.Year</th>
                                                        <th runat="server">ReleaseLabel</th>
                                                    </tr>
                                                    <tr runat="server" id="itemPlaceholder"></tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr runat="server">
                                            <td runat="server" style="text-align: center; background-color: #CCCCCC; font-family: Verdana, Arial, Helvetica, sans-serif; color: #000000;">
                                                <asp:DataPager runat="server" ID="DataPager1">
                                                    <Fields>
                                                        <asp:NextPreviousPagerField ButtonType="Button" ShowFirstPageButton="True" ShowLastPageButton="True"></asp:NextPreviousPagerField>
                                                    </Fields>
                                                </asp:DataPager>
                                            </td>
                                        </tr>
                                    </table>
                                </LayoutTemplate>
                                <SelectedItemTemplate>
                                    <tr style="background-color: #008A8C; font-weight: bold; color: #FFFFFF;">
                                        <td>
                                            <asp:Button runat="server" CommandName="Delete" Text="Delete" ID="DeleteButton" />
                                            <asp:Button runat="server" CommandName="Edit" Text="Edit" ID="EditButton" />
                                        </td>
                                        <td>
                                            <asp:Label Text='<%# Eval("AlbumId") %>' runat="server" ID="AlbumIdLabel" Width="50px"/></td>
                                        <td>
                                            <asp:Label Text='<%# Eval("Title") %>' runat="server" ID="TitleLabel" /></td>
                                        <td>
                                            <asp:DropDownList ID="ArtistIdDropDownList" runat="server" DataSourceID="ArtistListODS" DataTextField="Name" 
                                            DataValueField="ArtistId" SelectedValue='<%# Eval("ArtistId")%>'></asp:DropDownList></td>
                                        <td align="center">
                                            <asp:Label Text='<%# Eval("ReleaseYear") %>' runat="server" ID="ReleaseYearLabel" /></td>
                                        <td>
                                            <asp:Label Text='<%# Eval("ReleaseLabel") %>' runat="server" ID="ReleaseLabelLabel" /></td>
                                        <td>
                                            <asp:Label Text='<%# Eval("Artist") %>' runat="server" ID="ArtistLabel" /></td>
                                        <td>
                                            <asp:Label Text='<%# Eval("Tracks") %>' runat="server" ID="TracksLabel" /></td>
                                    </tr>
                                </SelectedItemTemplate>
                            </asp:ListView>
                            <asp:ObjectDataSource ID="ListViewODS" runat="server" DataObjectTypeName="Chinook.Data.Entities.Album" 
                                DeleteMethod="Albums_Delete" InsertMethod="Albums_Add" UpdateMethod="Albums_Update" SelectMethod="Albums_List" 
                                OldValuesParameterFormatString="original_{0}" TypeName="ChinookSystem.BLL.AlbumController" OnDeleted="CheckForException" 
                                OnInserted="CheckForException" OnUpdated="CheckForException" OnSelected="CheckForException">
                            </asp:ObjectDataSource>
                        </ContentTemplate>
                    </asp:UpdatePanel>

                </div> <%--eop--%>
            </div>
        </div>
         <%--Eval is one-way Bind is two-way. You CAN make everything Bind. Edit and Insert MUST be Bind!--%>

         <%-- some people will place all ODS controls in one location for ease of viewing. It is not necessary. Any ODS on the page is available to all tabs.--%>

         <%--to install a RadioButtonList, one can use the Edit Items to create the individual selections, one can change the default Vertical/Table layout by changing 
             the control properties, and remember to include your SelectedValue attribute (see RadioButtonList "gender" example above in the alternating view)--%>
    </div>
</asp:Content>

